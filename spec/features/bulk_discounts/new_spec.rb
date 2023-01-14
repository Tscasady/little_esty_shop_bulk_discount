require 'rails_helper'

RSpec.describe 'The Bulk Discount new page', type: :feature do
  
  let!(:merchant_1) { create(:merchant) }
  let!(:bulk_discount_1) { create(:bulk_discount, merchant: merchant_1, discount: 20, threshold: 10) }
  let!(:bulk_discount_2) { create(:bulk_discount, merchant: merchant_1, discount: 30, threshold: 15) }
  let!(:bulk_discount_3) { create(:bulk_discount, merchant: merchant_1, discount: 10, threshold: 5) }

  before(:each) do
    visit new_merchant_bulk_discount_path(merchant_1)
  end

  describe 'when a merchant visits the bulk discount new page' do
    it 'has a form to add a new discount' do
      expect(page).to have_field "Discount"
      expect(page).to have_field "Threshold"
      expect(page).to have_button "Submit"
    end
  end
end