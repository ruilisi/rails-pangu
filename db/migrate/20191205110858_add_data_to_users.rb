# frozen_string_literal: true

class AddDataToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :data, :jsonb, default: {}
  end
end
