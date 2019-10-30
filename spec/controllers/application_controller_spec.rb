# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  it 'ping returns text "pong"' do
    response = get :ping
    expect(response.body).to eq 'pong'
  end

  it 'auth_ping returns status 401 if not loggedin' do
    response = get :auth_ping
    expect(response.status).to eq 401
  end

  describe 'after logged in' do
    login_user

    it 'auth_ping returns text "pong"' do
      user = create(:user)
      sign_in(user)
      get :auth_ping
      expect(response.status).to eq 200
      expect(response.body).to eq 'pong'
    end
  end
end
