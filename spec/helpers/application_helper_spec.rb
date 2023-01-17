require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe 'price' do
    it 'transforms raw cents to dollar amount' do
      expect(price(1000)).to eq "$10.00"
    end
  end
end