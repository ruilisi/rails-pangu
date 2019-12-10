# frozen_string_literal: true

class MessagesController < ApplicationController
  def index
    conversation = Room.find(message_params[:room_id])
    messgaes = conversation.messages
    render json: messgaes
  end

  private

  def message_params
    params.permit(:text, :conversation_id, :user_id)
  end
end
