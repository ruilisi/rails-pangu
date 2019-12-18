# frozen_string_literal: true

Rails.application.routes.draw do
  resource :wechat, only: %i[show create]
  mount ActionCable.server => '/cable'
  resources :rooms, only: %i[index create destroy] do
    collection do
      post 'join_room'
      get 'user_list'
      post 'quit_room'
    end
  end
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  match 'ping' => 'application#ping', via: :all
  match 'data' => 'application#data', via: :all
  match 'auth_ping' => 'application#auth_ping', via: :all
  resources :wechats, only: %i[] do
    collection do
      match 'login_callback', via: :all
    end
  end

  extend QiniuRoutes if defined?(QiniuRoutes)
end
