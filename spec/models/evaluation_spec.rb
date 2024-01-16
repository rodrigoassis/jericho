require 'rails_helper'

RSpec.describe Evaluation, type: :model do
  describe 'associations' do
    it { should have_many(:conductive_paths) }
  end

  describe 'validations' do
    subject { build(:evaluation) }

    it { should validate_presence_of(:grid) }
    it { should be_valid }
  end

  describe 'grid validations' do
    subject { build(:evaluation, grid: '1234') }

    it { should_not be_valid }
  end

  describe 'conductive_paths creation' do
    subject { create(:evaluation, grid: "11\r\n11") }

    it 'creates conductive_paths' do
      expect { subject }.to change { ConductivePath.count }.by(2)
    end

    it 'sets positions' do
      expect(subject.conductive_paths.reload.first.positions).to eq([[0, 0], [1, 0]])
    end
  end
end
