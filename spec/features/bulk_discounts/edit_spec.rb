require 'rails_helper'

RSpec.describe 'The bulk discount edit page', type: :feature do

  let!(:merchant_1) { create(:merchant) }
  let!(:bd_1) { create(:bulk_discount, merchant: merchant_1) }

  before(:each) do
    visit merchant_bulk_discount_path(merchant_1, bd_1)
  end

  describe 'when a user visits the edit page ' do
    it 'has a form pre filled with discount information' do
      expect(page).to have_field "Discount", with: 20
      expect(page).to have_field "Threshold", with: 10
    end

    it 'redirects to the show page with updated information upon successful submission' do

    end

    describe "Sad Paths" do
      it 'will redirect back to this page with an error message if the information is invalid' do

      end
    end
  end
end