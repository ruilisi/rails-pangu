# frozen_string_literal: true

if ENV['QINIU_ENABLED'] == 'yes'
  require 'qiniu'
  Qiniu.establish_connection! access_key: ENV['QINIU_ACCESS_KEY'], secret_key: ENV['QINIU_SECRET_KEY']

  module QiniuRoutes
    def self.extended(router)
      router.instance_exec do
        match 'qiniu_token' => lambda { |_env|
          put_policy = Qiniu::Auth::PutPolicy.new(ENV['QINIU_BUCKET'])
          token = Qiniu::Auth.generate_uptoken(put_policy)

          [200, { 'Content-Type' => 'application/json' }, [{
            ok: true,
            qiniuToken: token,
            qiniuHost: ENV['QINIU_HOST']
          }.to_json]]
        }, via: :get
      end
    end
  end
end
