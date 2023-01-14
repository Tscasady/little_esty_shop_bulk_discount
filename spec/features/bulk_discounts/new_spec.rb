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

    it 'redirects back to the bulk index page when a discount is submitted' do
      fill_in "Discount", with: 20
      fill_in "Threshold", with: 25
      click_button "Submit"
      
      expect(current_path).to eq merchant_bulk_discounts_path(merchant_1)
    end

    describe 'it returns to the new page with an error message' do
      context 'if discount < 0' do
        it "displays ''" do
          fill_in "Discount", with: -2
          click_button "Submit"
          expect(current_path).to eq merchant_bulk_discounts_path(merchant_1)
          expect(page).to have_content ""
        end
      end

      context 'if discount > 100' do
        it '' do

        end
      end

      context 'if discount is a string' do
        it '' do

        end
      end

      context 'if threshold is < 0' do
        it '' do

        end
      end

      context 'if threshold is a string' do
        it '' do

        end
      end
    end
  end
end