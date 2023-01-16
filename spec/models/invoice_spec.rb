require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
  end
  describe "instance methods" do
    it "total_revenue" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

      expect(@invoice_1.total_revenue).to eq(100)
    end

    describe 'discounted_revenue' do
      before(:each) do
        @merchant1 = Merchant.create!(name: 'Hair Care')
        @merchant2 = Merchant.create!(name: 'Salon')
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 1000, merchant_id: @merchant1.id, status: 1)
        @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 50, merchant_id: @merchant1.id)
        @item_9 = Item.create!(name: "Hair Spray", description: "For style", unit_price: 1500, merchant_id: @merchant2.id)
        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      end

      it 'returns the discounted revenue if only one item is discounted' do
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 1000, status: 2)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 5, unit_price: 50, status: 1)
        @bd_1 = BulkDiscount.create!(threshold: 10, discount: 20, merchant: @merchant1)

        expect(@invoice_1.discounted_revenue).to eq(8250)
      end

      it 'returns the best discount when one item has multiple discounts available' do
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 1000, status: 2)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 50, status: 1)
        @bd_1 = BulkDiscount.create!(threshold: 10, discount: 20, merchant: @merchant1)
        @bd_2 = BulkDiscount.create!(threshold: 10, discount: 30, merchant: @merchant1)

        expect(@invoice_1.discounted_revenue).to eq(7050)
      end

      it 'can return the discount when one item has one discount, and one item has a different discount' do
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 1000, status: 2)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 5, unit_price: 50, status: 1)
        @bd_1 = BulkDiscount.create!(threshold: 10, discount: 20, merchant: @merchant1)
        @bd_2 = BulkDiscount.create!(threshold: 5, discount: 10, merchant: @merchant1)

        expect(@invoice_1.discounted_revenue).to eq(8225)
      end

      it 'returns the regular revenue when there are no discounts apply' do
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 1000, status: 2)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 5, unit_price: 50, status: 1)
        @bd_1 = BulkDiscount.create!(threshold: 30, discount: 20, merchant: @merchant1)

        expect(@invoice_1.discounted_revenue).to eq(10250)
      end

      it 'can return the discounted revenue without applying discounts to other merchants items' do
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 1000, status: 2)
        @ii_12 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_9.id, quantity: 5, unit_price: 1500, status: 1)
        @bd_1 = BulkDiscount.create!(threshold: 10, discount: 30, merchant: @merchant1)
        @bd_2 = BulkDiscount.create!(threshold: 5, discount: 20, merchant: @merchant1)

        expect(@invoice_1.discounted_revenue).to eq(14500)
      end
    end
  end
end
