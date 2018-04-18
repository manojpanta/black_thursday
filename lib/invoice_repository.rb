require 'csv'
require_relative 'invoice'
require 'time'
# this is invoice repo
class InvoiceRepository
  attr_reader :path,
              :invoices,
              :sales_engine,
              :merchant_ids

  def initialize(path, sales_engine)
    @sales_engine = sales_engine
    @path         = path
    @models       = {}
    @merchant_ids = Hash.new { |h, k| h[k] = [] }
    load_path(path)
  end

  def load_path(path)
    CSV.foreach(path, headers: true, header_converters: :symbol) do |data|
      invoice = Invoice.new(data, self)
      @models[invoice.id] = invoice
      @merchant_ids[invoice.merchant_id] << invoice
    end
  end

  def find_all_by_customer_id(customer_id)
    all.find_all do |model|
      model.customer_id == customer_id
    end
  end

  def find_all_by_merchant_id(merchant_id)
    @merchant_ids[merchant_id]
  end

  def find_all_by_status(status)
    all.find_all do |model|
      model.status == status
    end
  end

  def create(attributes)
    attributes[:id] = create_new_id
    attributes[:created_at] = Time.now.strftime('%F')
    attributes[:updated_at] = Time.now.strftime('%F')
    @models[attributes[:id]] = Invoice.new(attributes, self)
  end

  def update(id, attributes)
    return nil if find_by_id(id).nil?
    to_update = find_by_id(id)
    to_update.update_updated_time
    to_update.update_status(attributes[:status].to_sym) if attributes[:status]
  end

  def total_invoices_for_a_date(date)
    all.map do |model|
      model if model.created_at == date
    end.compact
  end

  def find_merchant_for_a_invoice(merchant_id)
    sales_engine.find_merchant_for_a_invoice(merchant_id)
  end

  def find_transactions_for_a_invoice(invoice_id)
    sales_engine.find_transactions_for_a_invoice(invoice_id)
  end

  def find_customer_of_a_invoice(customer_id)
    sales_engine.find_customer_of_a_invoice(customer_id)
  end

  def find_invoice_item_for_a_invoice(id)
    sales_engine.find_invoice_item_for_a_invoice(id)
  end

  def inspect
    "#<#{self.class} #{@models.size} rows>"
  end
end
