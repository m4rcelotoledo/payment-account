# frozen_string_literal: true

class Account < ApplicationRecord
  validates :account_number, presence: true, uniqueness: true, numericality: { only_integer: true, greater_than: 0 }
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
