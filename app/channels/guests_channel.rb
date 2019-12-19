# frozen_string_literal: true

class GuestsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "guest:#{current_user}"
  end

  def unsubscribed; end
end
