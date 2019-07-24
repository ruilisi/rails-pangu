# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email, 10) { |n| "tester#{n}@test.com" }
    password { 'Helloworld123' }
  end
end
