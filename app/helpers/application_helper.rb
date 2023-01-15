module ApplicationHelper
  def price(unit_price)
    number_to_currency(unit_price / 100.0)
  end
end
