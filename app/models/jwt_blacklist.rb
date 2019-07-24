# frozen_string_literal: true

class JWTBlacklist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Blacklist

  def self.jwt_revoked?(payload, user)
    # Check if in the blacklist
    $redis.get("user_blacklist:#{user.id}:#{payload['jti']}").present?
  end

  def self.revoke_jwt(payload, user)
    # REVOKE JWT
    expiration = payload['exp'] - payload['iat']
    $redis.setex("user_blacklist:#{user.id}:#{payload['jti']}", expiration, payload['jti'])
  end
end
