# frozen_string_literal: true

class RoomsChannel < ApplicationCable::Channel
  def subscribed
    stream_for room
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def load(_params)
    path = _params['path']
    data = _params['data']
    ret = { path: path, room_id: data['room_id'] }
    case path
    when 'messages'
      messages = Message.where(room_id: data['room_id'])
      ret['messages'] = messages
      avatars = {}
      ids = []
      if current_user.data['avatar']
        avatars[current_user.id] = current_user.data['avatar']
        ids << current_user.id
      end
      messages.map do |m|
        next if ids.include?(m.user_id)

        ids << m.user_id
        user = User.find_by_id(m.user_id)
        avatars[current_user.id] = current_user.data['avatar'] if user && current_user.data['avatar']
      end
      ret['avatars'] = avatars
    when 'add_message'
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
