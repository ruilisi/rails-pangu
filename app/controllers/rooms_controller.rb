# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :authenticate_user!

  def join_room
    title = params['title']
    room = Room.find_by_title(title)
    if room
      $redis.sadd("user:#{current_user.id}", room.id) if $redis.sadd("room:#{room.id}", current_user.id)
      render json: hash_by_id([room])
    else
      render json: { ok: false }
    end
  end

  def user_list
    id = params['id']
    users = User.where(id: $redis.smembers("room:#{id}")).map do |user|
      { email: user.email, id: user.id, avatar: user.data['avatar'] }
    end
    render json: users
  end

  def quit_room
    id = params['id']
    $redis.srem("user:#{current_user.id}", id) if $redis.srem("room:#{id}", current_user.id)
    render json: { id: id }
  end

  def index
    rooms = Room.where(id: $redis.smembers("user:#{current_user.id}"))
    render json: hash_by_id(rooms)
  end

  def create
    title = params[:title]
    render json: { ok: false } if title.blank?
    room = Room.new(title: title, user_id: current_user.id)
    return unless room.save

    $redis.sadd("room:#{room.id}", current_user.id)
    $redis.sadd("user:#{current_user.id}", room.id)
    render json: hash_by_id([room])
  end

  def destroy
    room = Room.find_by_id(params[:id])
    return render json: { ok: false } if room.user_id != current_user.id

    room.delete
    $redis.del("room:#{room.id}")
    $redis.srem("user:#{current_user.id}", room.id)
    render json: { id: room.id }
  end

  private

  def room_params
    params.permit(:title)
  end
end
