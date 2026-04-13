# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransactionService do
  describe '#call' do
    subject(:result) { described_class.new(account, payment_method, amount).call }

    let(:account) { create(:account, account_number: rand(1_000_000_000), balance: 100.0) }
    let(:amount) { 50.0 }

    context 'when payment method is invalid' do
      let(:payment_method) { 'X' }

      it 'returns invalid payment method error' do
        expect(result).to eq(success: false, error: :invalid_payment_method)
      end

      it 'does not change the account balance' do
        expect { result }.not_to(change { account.reload.balance })
      end
    end

    context 'when there are insufficient funds' do
      let(:payment_method) { 'C' }
      let(:amount) { 99.0 }

      it 'returns insufficient funds error' do
        expect(result).to eq(success: false, error: :insufficient_funds)
      end

      it 'does not change the account balance' do
        expect { result }.not_to(change { account.reload.balance })
      end
    end

    context 'when payment is via pix' do
      let(:payment_method) { 'P' }

      it 'deducts only the amount from account balance' do
        expect { result }.to change { account.reload.balance }.from(100.0).to(50.0)
      end

      it 'returns success with account' do
        expect(result).to include(success: true, account: account)
      end
    end

    context 'when payment is via debit card' do
      let(:payment_method) { 'D' }

      it 'deducts amount plus 3% fee from account balance' do
        expect { result }.to change { account.reload.balance }.from(100.0).to(48.5)
      end

      it 'returns success with account' do
        expect(result).to include(success: true, account: account)
      end
    end

    context 'when payment is via credit card' do
      let(:payment_method) { 'C' }

      it 'deducts amount plus 5% fee from account balance' do
        expect { result }.to change { account.reload.balance }.from(100.0).to(47.5)
      end

      it 'returns success with account' do
        expect(result).to include(success: true, account: account)
      end
    end
  end
end
