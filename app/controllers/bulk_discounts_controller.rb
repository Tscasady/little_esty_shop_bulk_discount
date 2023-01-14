class BulkDiscountsController < ApplicationController
  before_action :get_merchant, only: [:index, :new]

  def index
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show
  end

  def new
    @bulk_discount = BulkDiscount.new
  end

  private

  def get_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end