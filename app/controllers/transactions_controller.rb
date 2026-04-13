# frozen_string_literal: true

class TransactionsController < ApplicationController
  def create
    account = Account.find_by(account_number: transaction_params[:account_number])

    return render json: { error: 'Account not found' }, status: :not_found unless account

    result = TransactionService.new(account, transaction_params[:payment_method], transaction_params[:amount].to_d).call
    render_result(result, account)
  end

  private

  def render_result(result, account)
    if result[:success]
      render json: { account_number: account.account_number, balance: account.balance }, status: :created
    else
      render json: { error: result[:error] }, status: :not_found
    end
  end

  def transaction_params
    params.expect(transaction: %i[payment_method account_number amount])
  end
end
