# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Accounts' do
  describe 'POST /account' do
    context 'when params are valid' do
      it 'creates an account and returns 201' do
        post '/account', params: { account: { account_number: 123, balance: 100.0 } }

        expect(response).to have_http_status(:created)
        expect(response.parsed_body).to include('account_number' => 123, 'balance' => '100.0')
      end
    end

    context 'when account already exists' do
      before { create(:account, account_number: 123) }

      it 'returns 422' do
        post '/account', params: { account: { account_number: 123, balance: 50.0 } }

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'GET /account' do
    context 'when account exists' do
      let(:account) { create(:account, account_number: 234, balance: 180.37) }

      it 'returns the account' do
        get '/account', params: { account_number: account.account_number }

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to include('account_number' => 234, 'balance' => '180.37')
      end
    end

    context 'when account does not exist' do
      it 'returns 404' do
        get '/account', params: { account_number: 999 }

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
