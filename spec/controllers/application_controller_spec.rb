require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  it 'ping returns pong' do
    response = get :ping
    expect(response.body).to eq 'pong'
  end
end
