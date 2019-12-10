# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages, id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
      t.string :text
      t.uuid :room_id, null: false
      t.uuid :user_id, null: false
      t.jsonb :data, null: false, default: {}
      t.timestamps
    end
  end
end
