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

    it 'when submitted it redirects back to the bulk index page and displays the new discount' do
      fill_in "Discount", with: 20
      fill_in "Threshold", with: 25
      click_button "Submit"
      new_discount = BulkDiscount.last

      expect(current_path).to eq merchant_bulk_discounts_path(merchant_1)

      within("#bulk_discount_#{new_discount.id}") do
        expect(page).to have_content "#{new_discount.id}"
      end
    end

    describe 'it returns to the new page with an error message if invalid data is given' do
      context 'if discount < 0' do
        it "displays discountmust be greater than 0" do
          fill_in "Discount", with: -2
          fill_in "Threshold", with: 10
          click_button "Submit"
          expect(current_path).to eq new_merchant_bulk_discount_path(merchant_1)
          expect(page).to have_content "Discount must be greater than 0"
        end
      end

      context 'if discount < 100' do
        it 'displays discount must be less than 100' do
          fill_in "Discount", with: 110 
          fill_in "Threshold", with: 10
          click_button "Submit"
          expect(current_path).to eq new_merchant_bulk_discount_path(merchant_1)
          expect(page).to have_content "Discount must be less than 100"
        end
      end

      context 'if discount is a string' do
        it 'displays that discount is not a number' do
          fill_in "Discount", with: "Big Discount"
          fill_in "Threshold", with: 10
          click_button "Submit"
          expect(current_path).to eq new_merchant_bulk_discount_path(merchant_1)
          expect(page).to have_content "Discount is not a number"
        end
      end

      context 'if threshold is < 0' do
        it 'displays threshold must be greater than 0' do
          fill_in "Discount", with: 20
          fill_in "Threshold", with: -10
          click_button "Submit"
          expect(current_path).to eq new_merchant_bulk_discount_path(merchant_1)
          expect(page).to have_content "Threshold must be greater than 0"
        end
      end

      context 'if threshold is a string' do
        it 'displays threshold is not a number' do
          fill_in "Discount", with: 20
          fill_in "Threshold", with: "A few items"
          click_button "Submit"
          expect(current_path).to eq new_merchant_bulk_discount_path(merchant_1)
          expect(page).to have_content "Threshold is not a number"
        end
      end
    end
  end
end