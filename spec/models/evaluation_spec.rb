require 'rails_helper'

RSpec.describe Evaluation, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:grid) }
  end
end
