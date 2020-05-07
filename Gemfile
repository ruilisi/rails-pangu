# frozen_string_literal: true

gemfiles = ['Gemfile.core']
gemfiles.each do |gemfile|
  instance_eval File.read(gemfile)
end
gem 'devise', '>= 4.7.1'
gem 'devise-jwt'
gem 'qiniu'
gem 'wechat'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'figaro', '~> 1.1.1'
end
