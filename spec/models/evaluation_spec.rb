require 'rails_helper'

RSpec.describe Evaluation, type: :model do
  describe 'validations' do
    subject { build(:evaluation) }

    it { should validate_presence_of(:grid) }
    it { should be_valid }
  end

  describe 'grid validations' do
    subject { build(:evaluation, grid: '1234') }

    it { should_not be_valid }
  end
end
