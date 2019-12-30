# frozen_string_literal: true

class RoomsChannel < ApplicationCable::Channel
  def subscribed
    stream_for room
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def load(params)
    # rubocop:enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
    path = params['path']
    data = params['data']
    ret = { path: path, room_id: data['room_id'] }
    case path
    when 'messages'
      messages = Message.where(room_id: data['room_id']).order('created_at')
      ret['messages'] = messages
    when 'delete_message'
      message = Message.find_by_id(data['message_id'])
      if message.user_id == current_user.id
        message.delete
        ret['message_id'] = message.id
      else
        ret['error'] = "You can't delete others's message"
      end
    when 'update_message'
      message = Message.find_by_id(data['message_id'])
      if message.user_id == current_user.id
        message.update(text: data['text'])
        ret['message'] = message
      else
        ret['error'] = "You can't edit others's message"
      end
    when 'add_message', 'join_room'
      text = data['text']
      case text
      when %r{^/vote}
        _, title, *choices = text.split(' ')
        message = Message.new(data.merge(user_id: current_user.id, data: {
                                           email: current_user.email,
                                           type: 'vote',
                                           title: title,
                                           choices: choices.map { |c| [c, []] }
                                         }))
      else
        message = Message.new(data.merge(user_id: current_user.id, data: { email: current_user.email }))
      end
      ret['message'] = message if message.save
    when 'vote'
      message = Message.find(data['message_id'])
      index = data['index']
      message.data['choices'].each_with_index do |(_, voted_users), i|
        user_id = current_user.id
        included = voted_users.include?(user_id)
        is_index = index == i
        voted_users.delete(user_id) if included && !is_index
        voted_users.push(user_id) if !included && is_index
      end
      return unless message.changed?

      message.save
      ret[:message] = message
      ret[:path] = 'update_message'
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
