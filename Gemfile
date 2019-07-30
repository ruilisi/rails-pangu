# frozen_string_literal: true

gemfiles = ['Gemfile.core']
gemfiles.each do |gemfile|
  instance_eval File.read(gemfile)
end
gem 'devise'
gem 'devise-jwt'
gem 'mailgun-ruby', git: 'https://github.com/paiyou-network/mailgun-ruby', ref: '423399cca1398c53a8042a22c70b683f2857ed6e'
