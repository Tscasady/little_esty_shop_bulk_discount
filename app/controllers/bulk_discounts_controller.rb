class BulkDiscountsController < ApplicationController
  before_action :get_merchant, only: [:index]

  def index
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show
   require 'pry'; binding.pry 
  end

  private

  def get_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end