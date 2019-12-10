# frozen_string_literal: true

class RoomsController < ApplicationController
  def index
    rooms = Room.all
    render json: hash_by_id(rooms)
  end

  def create
    room = Room.new(room_params)
    if room.save
      serialized_data = ActiveModelSerializers::Adapter::Json.new(
        RoomSerializer.new(room)
      ).serializable_hash
      ActionCable.server.broadcast 'rooms_channel', serialized_data
      head :ok
    end
  end

  private

  def room_params
    params.permit(:title, :user_id)
  end
end
