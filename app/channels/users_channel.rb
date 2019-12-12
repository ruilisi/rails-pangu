# frozen_string_literal: true

class UsersChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  def unsubscribed; end

  def load(params)
    path = params['path']
    data = params['data']

    case path
    when 'set_avatar'
      current_user.data['avatar'] = data['avatar']
      current_user.save
    end

    UsersChannel.broadcast_to current_user, path: 'self', data: current_user
  end
end
