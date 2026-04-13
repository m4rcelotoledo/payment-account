# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account do
  subject { build(:account) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:account_number) }
    it { is_expected.to validate_uniqueness_of(:account_number) }
    it { is_expected.to validate_numericality_of(:account_number).only_integer.is_greater_than(0) }
    it { is_expected.to validate_presence_of(:balance) }
    it { is_expected.to validate_numericality_of(:balance).is_greater_than_or_equal_to(0) }
  end
end
