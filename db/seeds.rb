# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

first_user = User.create(email: 'info@pangu', password: 'Pangu123')
%w[rails javascript actioncable ruby react chat].each do |title|
  Room.create(title: title, user_id: first_user.id)
end
