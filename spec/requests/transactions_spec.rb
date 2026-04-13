# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Transactions' do
  let(:account) { create(:account, account_number: 234, balance: 180.37) }

  describe 'POST /transaction' do
    context 'when payment method is Pix' do
      it 'deducts exact amount and returns 201' do
        post '/transaction', params: {
          transaction: { payment_method: 'P', account_number: account.account_number, amount: 10.0 }
        }

        expect(response).to have_http_status(:created)
        expect(response.parsed_body['balance']).to eq('170.37')
      end
    end

    context 'when payment method is Debit' do
      it 'deducts amount plus 3% fee and returns 201' do
        post '/transaction', params: {
          transaction: { payment_method: 'D', account_number: account.account_number, amount: 10.0 }
        }

        expect(response).to have_http_status(:created)
        expect(response.parsed_body['balance']).to eq('170.07')
      end
    end

    context 'when payment method is Credit' do
      it 'deducts amount plus 5% fee and returns 201' do
        post '/transaction', params: {
          transaction: { payment_method: 'C', account_number: account.account_number, amount: 10.0 }
        }

        expect(response).to have_http_status(:created)
        expect(response.parsed_body['balance']).to eq('169.87')
      end
    end

    context 'when balance is insufficient' do
      it 'returns 404' do
        post '/transaction', params: {
          transaction: { payment_method: 'P', account_number: account.account_number, amount: 999.0 }
        }

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when account does not exist' do
      it 'returns 404' do
        post '/transaction', params: { transaction: { payment_method: 'P', account_number: 999, amount: 10.0 } }

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when payment method is invalid' do
      it 'returns 404' do
        post '/transaction', params: {
          transaction: { payment_method: 'X', account_number: account.account_number, amount: 10.0 }
        }

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
