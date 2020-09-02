class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  validates :name, presence: true

  def self.most_revenue(quantity)
    joins(invoices: :items).joins(invoices: :transactions)
    .select("merchants.*, SUM(invoice_items.unit_price * invoice_items.quantity) AS revenue")
    .merge(Transaction.successful)
    .group('merchants.id')
    .order('revenue DESC')
    .limit(quantity)
  end
end
