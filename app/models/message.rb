# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :room
  belongs_to :user

  attr_accessor :email
end
