require 'time'
class Invoice
  attr_reader :id,
              :customer_id,
              :merchant_id,
              :status,
              :created_at,
              :updated_at,
              :invoice_repo
  def initialize(data, invoice_repo)
    @invoice_repo = invoice_repo
    @id           = data[:id].to_i
    @customer_id  = data[:customer_id].to_i
    @merchant_id  = data[:merchant_id].to_i
    @status       = data[:status].to_sym
    @created_at   = Time.parse(data[:created_at])
    @updated_at   = Time.parse(data[:updated_at])
  end

  def merchant
    invoice_repo.find_merchant_for_a_invoice(merchant_id)
  end

  def update_updated_time
    @updated_at = Time.now
  end

  def update_status(status)
    @status = status
  end

  def items
    invoice_items = invoice_repo.find_invoice_item_for_a_invoice(id)
    invoice_items.map do |invoice_item|
      @invoice_repo.sales_engine.items.find_by_id(invoice_item.item_id)
    end.uniq
  end

  def transactions
    @invoice_repo.find_transactions_for_a_invoice(id)
  end

  def customer
    @invoice_repo.find_customer_of_a_invoice(customer_id)
  end

  def is_paid_in_full?
    transactions.any? do |transaction|
      transaction.result == :success
    end
  end

  def invoice_total(id)
    invoice_items = invoice_repo.find_invoice_item_for_a_invoice(id)
    invoice_items.reduce(0) do |sum, invoice_item|
      if is_paid_in_full?
        sum + (invoice_item.quantity * invoice_item.unit_price)
      end
    end
  end
end
