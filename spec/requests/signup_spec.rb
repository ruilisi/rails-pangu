# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /signup', type: :request do
  let(:url) { '/users/sign_up' }
  let(:params) do
    {
      user: {
        email: 'user@example.com',
        password: 'password'
      }
    }
  end

  context 'when user is unauthenticated' do
    before { get url, params: params }

    it 'returns 200' do
      expect(response.status).to eq 200
    end

    it 'returns a new user' do
      user = JSON.parse(response.body)
      expect(user).to include('id', 'email')
    end
  end

  context 'when user already exists' do
    before do
      create(:user, email: params[:user][:email])
      get url, params: params
    end

    it 'returns bad request status' do
      expect(response.status).to eq 400
    end
  end
end
