class BulkDiscountsController < ApplicationController
  before_action :get_merchant, except: [:update] 
  before_action :get_bulk_discount, only: [:destroy, :show, :edit, :update]

  def index
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show
  end

  def new
    @bulk_discount = BulkDiscount.new
  end

  def edit
  end

  def update
    if @bulk_discount.update(bulk_discount_params)
      redirect_to merchant_bulk_discount_path
    else
      flash[:alert] = bulk_discount.errors.full_messages.to_sentence
      redirect_to edit_merchant_bulk_discount_path
    end
  end

  def create
    bulk_discount = @merchant.bulk_discounts.new(bulk_discount_params)
    if bulk_discount.save(bulk_discount_params)
      redirect_to merchant_bulk_discounts_path
    else
      flash[:alert] = bulk_discount.errors.full_messages.to_sentence
      redirect_to new_merchant_bulk_discount_path
    end
  end

  def destroy
    @bulk_discount.destroy
    redirect_to merchant_bulk_discounts_path 
  end
  private

  def get_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def get_bulk_discount
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def bulk_discount_params
    params.require(:bulk_discount).permit(:discount, :threshold)
  end
end