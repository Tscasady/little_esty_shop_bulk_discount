require 'rails_helper'

RSpec.describe 'The Bulk Discount Show page', type: :feature do
  describe 'displays discount info' do
    
    let!(:merchant_1) { create(:merchant) }
    let!(:bd_1) { create(:bulk_discount, merchant: merchant_1) }

    before(:each) do
      visit merchant_bulk_discount_path(merchant_1, bd_1)
    end

    it 'displays the name, threshold, and percent discount of the bulk discount' do
      expect(page).to have_content "Discount Name: #{bd_1.name}"
      expect(page).to have_content "Discount: #{bd_1.discount}%"
      expect(page).to have_content "Threshold: #{bd_1.threshold}"
    end

    it 'has a link to edit the bulk discount and it redirects to the edit page' do
      expect(page).to have_link "Edit Discount"
      click_link "Edit Discount"
      expect(current_path).to eq edit_merchant_bulk_discount_path(merchant_1, bd_1)
    end
  end
end