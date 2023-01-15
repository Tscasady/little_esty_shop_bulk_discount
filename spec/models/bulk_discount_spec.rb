require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe 'relations' do
    it { should belong_to :merchant }
    it { should have_many(:items).through(:merchant) }
    it { should have_many(:invoice_items).through(:items) }
  end

  describe 'validations' do
    it { should validate_numericality_of :discount }
    it { should validate_numericality_of(:discount).is_greater_than 0 }
    it { should validate_numericality_of(:discount).is_less_than 100 }
    it { should validate_numericality_of :threshold }
    it { should validate_numericality_of(:threshold).is_greater_than 0 }
  end
end