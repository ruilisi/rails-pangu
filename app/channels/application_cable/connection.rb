# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected

    def find_verified_user
      token = request.headers[:HTTP_SEC_WEBSOCKET_PROTOCOL].split(',').last.strip
      if token.start_with?('GUEST')
        token
      elsif (current_user = UtilJwt.user_from_jwt_token(token))
        current_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
