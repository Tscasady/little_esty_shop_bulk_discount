class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates_numericality_of :discount, greater_than: 0, less_than: 100
  validates_numericality_of :threshold, greater_than: 0
end