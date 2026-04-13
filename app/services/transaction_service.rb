# frozen_string_literal: true

class TransactionService
  FEES = {
    'P' => 0.0,  # Pix
    'D' => 0.03, # Debit Card
    'C' => 0.05  # Credit Card
  }.freeze

  def initialize(account, payment_method, amount)
    @account = account
    @payment_method = payment_method
    @amount = amount
  end

  def call
    return { success: false, error: :invalid_payment_method } unless valid_payment_method?

    total = @amount * (1 + FEES[@payment_method])

    return { success: false, error: :insufficient_funds } if @account.balance < total

    @account.balance -= total
    @account.save!

    { success: true, account: @account }
  end

  private

  def valid_payment_method?
    FEES.key?(@payment_method)
  end
end
