# frozen_string_literal: true

class AccountsController < ApplicationController
  def show
    account = Account.find_by(account_number: params[:account_number])

    if account
      render json: account_response(account), status: :ok
    else
      render json: { error: 'Account not found' }, status: :not_found
    end
  end

  def create
    account = Account.new(account_params)

    if account.save
      render json: account_response(account), status: :created
    else
      render json: { errors: account.errors.full_messages }, status: :unprocessable_content
    end
  end

  private

  def account_params
    params.expect(account: %i[account_number balance])
  end

  def account_response(account)
    { account_number: account.account_number, balance: account.balance }
  end
end
