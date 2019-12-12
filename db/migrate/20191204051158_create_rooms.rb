# frozen_string_literal: true

class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms, id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
      t.string :title
      t.uuid :user_id, null: false

      t.timestamps
    end
  end
end
