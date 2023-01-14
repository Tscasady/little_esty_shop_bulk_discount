require 'rails_helper'

RSpec.describe 'The bulk discount index page', type: :feature do
  describe 'when a merchant visits their bulk discount page' do

    let!(:merchant_1) { create(:merchant) }
    let!(:bulk_discount_1) { create(:bulk_discount, merchant: merchant_1, discount: 20, threshold: 10) }
    let!(:bulk_discount_2) { create(:bulk_discount, merchant: merchant_1, discount: 30, threshold: 15) }
    let!(:bulk_discount_3) { create(:bulk_discount, merchant: merchant_1, discount: 10, threshold: 5) }

    before(:each) do
      visit merchant_bulk_discounts_path(merchant_1)
    end
    it 'displays all discounts with their percentage and thresholds' do

      expect(page).to have_content "Discount: #{merchant_1.bulk_discounts.first.discount}"      
      expect(page).to have_content "Discount: #{merchant_1.bulk_discounts.second.discount}"      
      expect(page).to have_content "Discount: #{merchant_1.bulk_discounts.third.discount}"      
      expect(page).to have_content "Threshold: #{merchant_1.bulk_discounts.first.threshold}"      
      expect(page).to have_content "Threshold: #{merchant_1.bulk_discounts.second.threshold}"      
      expect(page).to have_content "Threshold: #{merchant_1.bulk_discounts.third.threshold}"      
    end

    it 'has a link to each discount show page' do
      expect(page).to have_link "Discount Info", count: merchant_1.bulk_discounts.length
    end

    describe 'Delete Link' do
      it 'has a delete link for each discount' do
        merchant_1.bulk_discounts.each do |bulk_discount|
          within("#bulk_discount_#{bulk_discount.id}") do
            expect(page).to have_link 'Delete Discount'
          end
        end
      end

      it 'deletes a discount and redirects back to the index page' do
        bd = merchant_1.bulk_discounts.first
        within("#bulk_discount_#{bd.id}") do
          click_link "Delete Discount"
        end

        expect(current_path).to eq merchant_bulk_discounts_path(merchant_1)
        expect(page).to_not have_selector "bulk_discount_#{bd.id}"
      end
    end

    it 'has a link to create a new discount' do
      expect(page).to have_button "Create Discount"

      click_button "Create Discount"

      expect(current_path).to eq new_merchant_bulk_discount_path(merchant_1)
    end
  end
end