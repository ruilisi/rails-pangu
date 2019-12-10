# frozen_string_literal: true

class RoomsController < ApplicationController
  def index
    rooms = Room.all
    render json: hash_by_id(rooms)
  end

  private

  def room_params
    params.permit(:title, :user_id)
  end
end
