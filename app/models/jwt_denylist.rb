# frozen_string_literal: true

class JwtDenylist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist

  def self.jwt_revoked?(payload, user)
    $redis.exists?("user_denylist:#{user.id}:#{payload['jti']}")
  end

  def self.revoke_jwt(payload, user)
    expiration = payload['exp'] - payload['iat']
    $redis.setex("user_denylist:#{user.id}:#{payload['jti']}", expiration, payload['jti'])
  end
end
