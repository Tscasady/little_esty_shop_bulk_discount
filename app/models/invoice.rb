class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :items

  enum status: [:cancelled, 'in progress', :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discounted_revenue
      condition = "CASE WHEN bulk_discounts.threshold <= invoice_items.quantity
                    THEN invoice_items.unit_price * invoice_items.quantity * (1 - (bulk_discounts.discount / 100.0 )) 
                    ELSE invoice_items.unit_price * invoice_items.quantity END" 
      sub = self.invoice_items.select("invoice_items.id, min(#{condition}) as min_total")
        .left_joins(:bulk_discounts).group('invoice_items.id')

        InvoiceItem.select('sum(sub.min_total) as total').from(sub, :sub).take.total

      # self.invoice_items.left_joins(:bulk_discounts)
      #   .select("invoice_items.invoice_id, min(#{condition}) as minimum_total")
      #   .group("invoice_items.invoice_id")
      #   # sub = invoice_1.invoice_items.left_joins(:bulk_discounts).select("invoice_items.invoice_id, min(#{condition}) as minimum_total").group(:invoice_id, 'invoice_items.id'
      #   # ) 
        # .group(:id, 'bulk_discounts.discount', 'bulk_discounts.threshold')
        # .select(condition)
        # .having('bulk_discounts.threshold = max(bulk_discounts.threshold)')
        # .where('bulk_discounts.threshold = (:thresholds)', thresholds: BulkDiscount.select('max(bulk_discounts.threshold)'))
        # .sum(condition)
        # .having('max(bulk_discounts.threshold) = bulk_discounts.threshold')
      # .where('invoice_items.quantity >= bulk_discounts.threshold')
      # .where('max(bulk_discounts.threshold')
      # Invoice.joins(:invoice_items).where('invoice_items.invoice_id = ?', 901).left_joins(:bulk_discounts).select("invoices.id", "sum(#{condition}) as total").group(:id)
      # invoice_items.unit_price * invoice_items.quantity as revenue
      # invoice_items.unit_price * invoice_items.quantity * (1 - (bulk_discounts.discount / 100.0 )) as discounted_revenue
      # IF(invoice_items.quantity >= bulk_discounts.threshold, discounted_revenue, revenue) as final_revenue
      # .invoice_items.left_joins(:bulk_discounts).select("invoice_items.unit_price * invoice_items.quantity as revenue, invoice_items
      #   .unit_price * invoice_items.quantity * (1 - (bulk_discounts.discount / 100.0 )) as discounted_revenue").group(:invoice_id).
  end
end
