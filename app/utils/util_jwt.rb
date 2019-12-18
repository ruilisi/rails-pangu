# frozen_string_literal: true

module UtilJwt
  class << self
    def user_from_jwt_token(token)
      return nil if token.nil?

      begin
        Warden::JWTAuth::UserDecoder.new.call(token, :user, nil)
      rescue
      end 
    end

    def generate_new_authorization(user)
      token, payload = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
      "Bearer #{token}"
    end

    def user_from_authorization(authorization)
      return nil if authorization.nil?

      user_from_jwt_token(authorization.split(' ').last)
    end
  end
end
