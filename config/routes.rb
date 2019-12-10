# frozen_string_literal: true

Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  resources :rooms, only: %i[index]
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  match 'ping' => 'application#ping', via: :all
  match 'auth_ping' => 'application#auth_ping', via: :all

  extend QiniuRoutes if defined?(QiniuRoutes)
end
