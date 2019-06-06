class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::JWT::RevocationStrategies::Blacklist
  devise :database_authenticatable, :registerable, :rememberable, :timeoutable, :jwt_authenticatable, jwt_revocation_strategy: JWTBlacklist
end
