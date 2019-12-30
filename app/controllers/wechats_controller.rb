# frozen_string_literal: true

class WechatsController < ApplicationController
  # For details on the DSL available within this file, see https://github.com/Eric-Guo/wechat#wechat_responder---rails-responder-controller-dsl
  wechat_responder

  on :text do |request, content|
    request.reply.text "echo: #{content}" # Just echo
  end

  def login_callback
    guest = params[:guest]
    data = Wechat.api.web_access_token(params[:code])
    data = Wechat.api.web_userinfo(data['access_token'], data['unionid'])
    user = User.where("data ->> 'unionid' = ? ", data['unionid']).first
    user ||= User.create(email: data['nickname'], data: { unionid: data['unionid'], avatar: data['headimgurl'] })
    ActionCable.server.broadcast "guest:#{guest}", path: 'wechat_login', data: UtilJwt.generate_new_authorization(user)

    # rubocop:disable Lint/ImplicitStringConcatenation
    html = '''<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <script type="application/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.4.0.js"></script>
    <script>
      document.addEventListener("WeixinJSBridgeReady", function(){ WeixinJSBridge.call("closeWindow"); }, false);
    </script>
  </head>
  <body>
  </body>
</html>
'''
    # rubocop:enable Lint/ImplicitStringConcatenation
    render html: html.html_safe
  end
end
