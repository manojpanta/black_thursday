require 'csv'
require_relative 'invoice'
require 'time'

class InvoiceRepository
  attr_reader :path,
              :invoices,
              :sales_engine

  def initialize(path, sales_engine)
    @sales_engine ||= sales_engine
    @path = path
    @invoices = {}
    @merchant_ids = Hash.new{|h, k| h[k] = []}
    load_path(path)
  end

  def load_path(path)
    CSV.foreach(path, headers: true, header_converters: :symbol) do |data|
      invoice = Invoice.new(data, self)
      @invoices[invoice.id] = invoice
      @merchant_ids[invoice.merchant_id] << invoice
    end
  end

  def all
    @invoices
  end

  def find_by_id(id)
    @invoices[id]
  end

  def find_all_by_customer_id(customer_id)
    @invoices.find_all do |invoice|
      invoice.customer_id == customer_id
    end
  end

  def find_all_by_merchant_id(merchant_id)
    @merchant_ids[merchant_id]
  end

  def find_all_by_status(status)
    @invoices.find_all do |invoice|
      invoice.status == status
    end
  end

  def create_new_id
    @invoices.map do |invoice|
      invoice.id
    end.max + 1
  end

  def create(attributes)
    attributes[:id] = create_new_id
    attributes[:created_at] = Time.now.strftime('%F')
    attributes[:updated_at] = Time.now.strftime('%F')
    @invoices << Invoice.new(attributes, self)
  end

  def update(id, attributes)
    return nil if find_by_id(id).nil?
    to_update = find_by_id(id)
    to_update.update_updated_time
    to_update.update_status(attributes[:status].to_sym) if attributes[:status]
  end

  def delete(id)
    @invoices.delete(find_by_id(id))
  end

  def total_invoices_for_a_date(date)
    @invoices.map do |invoice|
      invoice if invoice.created_at == date
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

  def inspect
    "#<#{self.class} #{@invoices.size} rows>"
  end
end
