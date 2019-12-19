# frozen_string_literal: true

class RoomsChannel < ApplicationCable::Channel
  def subscribed
    stream_for room
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def load(params)
    path = params['path']
    data = params['data']
    ret = { path: path, room_id: data['room_id'] }
    case path
    when 'messages'
      messages = Message.where(room_id: data['room_id']).order('created_at')
      ret['messages'] = messages
    when 'add_message', 'join_room'
      message = Message.new(data.merge(user_id: current_user.id, data: { email: current_user.email }))
      ret['message'] = message if message.save
    end
    RoomsChannel.broadcast_to room, ret
  end

  private

  def room
    @room ||= Room.find(params['room_id'])
  end

  def user
    @user ||= UtilJwt.user_from_authorization(params['authorization'])
  end
end
