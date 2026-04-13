# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[8.1]
  def change
    create_table :accounts do |t|
      t.integer :account_number, null: false
      t.decimal :balance, precision: 15, scale: 2, null: false

      t.timestamps
    end

    add_index :accounts, :account_number, unique: true
  end
end
