class JWTBlacklist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Blacklist

  def self.jwt_revoked?(payload, user)
    # Check if in the blacklist
    $redis.get("user_device_jwt:#{user.id}:#{payload['device']}:#{payload['jti']}").present?
  end

  def self.revoke_jwt(payload, user)
    # REVOKE JWT
    expiration = payload['exp'] - payload['iat']
    $redis.setex("user_device_jwt:#{user.id}:#{payload['device']}:#{payload['jti']}", expiration, payload['jti'])
    $redis.del("user_login:#{user.id}:#{payload['device']}")
  end
end
