require 'rails_helper'

RSpec.describe "Users::Sessions", type: :request do
  let(:user) { create(:user) }

  describe "GET /users/sign_in" do
    let(:url) { '/users/sign_in' }
    let(:params) do
      {
        user: {
          email: user.email,
          password: user.password
        }
      }
    end

    context 'when params are correct' do
      before do
        post url, params: params
      end

      it 'returns 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns JTW token in authorization header' do
        expect(response.headers['Authorization']).to be_present
      end

      it 'returns valid JWT token' do
        decoded_token = decoded_jwt_token_from_response(response)
        expect(decoded_token.first['sub']).to be_present
      end
    end

    context 'when login params are incorrect' do
      before { post url }

      it 'returns unathorized status' do
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE /users/sign_out' do
    let(:url) { '/users/sign_in' }
    let(:params) do
      {
        user: {
          email: user.email,
          password: user.password
        }
      }
    end

    before(:each) do
      post url, params: params
    end

    it 'sign_out with token' do
      token = response.headers['Authorization']
      expect(token).to be_present
      delete '/users/sign_out', headers: { Authorization: token }
      expect(response).to have_http_status(204)
      get '/auth_ping', headers: { Authorization: token }
      expect(response).to have_http_status(401)
    end

    it 'sign_out without token' do
      token = response.headers['Authorization']
      expect(token).to be_present
      delete '/users/sign_out'
      expect(response).to have_http_status(204)
      get '/auth_ping', headers: { Authorization: token }
      expect(response).to have_http_status(200)
    end
  end
end
