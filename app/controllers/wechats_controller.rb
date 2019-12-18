# frozen_string_literal: true

class WechatsController < ApplicationController
  # For details on the DSL available within this file, see https://github.com/Eric-Guo/wechat#wechat_responder---rails-responder-controller-dsl
  wechat_responder

  on :text do |request, content|
    request.reply.text "echo: #{content}" # Just echo
  end

  def login_callback
    data = Wechat.api.web_access_token(params[:code])
    data = Wechat.api.web_userinfo(data['access_token'], data['unionid'])
    user = User.find_by_unionid(data['unionid'])
    if user
      UsersChannel.broadcast_to User.traveler_user, path: 'wechat_login', data: UtilJwt.generate_new_authorization(user)
    else
      UsersChannel.broadcast_to User.traveler_user, path: 'wechat_login', data: UtilJwt.generate_new_authorization(User.create(unionid: data['unionid']))
    end
    render json: data
  end
end
