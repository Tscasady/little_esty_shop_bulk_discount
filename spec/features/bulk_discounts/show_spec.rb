require 'rails_helper'

RSpec.describe 'The Bulk Discount Show page', type: :feature do
  describe 'displays discount info' do
    
    let!(:merchant_1) { create(:merchant) }
    let!(:bd_1) { create(:bulk_discount, merchant: merchant_1) }

    before(:each) do
      visit merchant_bulk_discount_path(merchant_1, bd_1)
    end

    it 'displays threshold and percent discount of the bulk discount' do
      expect(page).to have_content "Discount: #{bd_1.discount}%"
      expect(page).to have_content "Threshold: #{bd_1.threshold}"
    end
  end
end