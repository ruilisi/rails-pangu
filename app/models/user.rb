class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :timeoutable, :jwt_authenticatable, jwt_revocation_strategy: JWTBlacklist

  attr_accessor :device_type

  def device_type
    @device_type || ''
  end

  # Set other keys in payload, you can also append them in blacklist redis key
  def jwt_payload
     { 'device' => device_type }
  end

  # The following method will be called on dispatching a jwt auth, You can set rules to revork jwt here
  # The following is to set one device_type can only be logged in by jwt by at most one user at each time
  def on_jwt_dispatch(token, payload)
    # In the following example, keys start with user_device_jwt to record whether the jwt is used for login
    # The keys start with user_blacklist to record the last active jwt for the device
    last_jwt = $redis.get("user_device_jwt:#{self.id}:#{payload['device']}")
    if last_jwt.present?
      jti, exp = last_jwt.split(":")
      expiration = exp.to_i - Time.now.to_i
      if expiration > 0
        $redis.setex("user_blacklist:#{self.id}:#{payload['device']}:#{jti}", expiration, jti)
      end
    end
    $redis.setex("user_device_jwt):#{self.id}:#{payload['device']}", payload['exp'] - Time.now.to_i, "#{payload['jti']}:#{payload['exp']}")
  end
end
