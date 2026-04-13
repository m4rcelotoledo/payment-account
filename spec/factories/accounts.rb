# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    sequence(:account_number) { |n| n }
    balance { Faker::Commerce.price(range: 0..1000.0) }
  end
end
