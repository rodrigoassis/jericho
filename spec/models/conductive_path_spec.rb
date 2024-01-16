require 'rails_helper'

RSpec.describe ConductivePath, type: :model do
  describe 'associations' do
    it { should belong_to(:evaluation) }
  end
end
