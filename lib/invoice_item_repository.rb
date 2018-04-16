require 'csv'
require_relative 'invoice_item'
class InvoiceItemRepository
  attr_reader :invoice_items

  def initialize(path, sales_engine)
    @sales_engine||= sales_engine
    @invoice_items = {}
    @invoice_id    = Hash.new{|h, k| h[k] = []}
    load_path(path)
  end

  def all
    @invoice_items.values
  end

  def load_path(path)
    CSV.foreach(path, headers: true, header_converters: :symbol) do |data|
      invoice_item = InvoiceItem.new(data, self)
      @invoice_items[invoice_item.id] = invoice_item
      @invoice_id[invoice_item.invoice_id] << invoice_item
    end
  end

  def find_by_id(id)
    @invoice_items[id]
  end

  def find_all_by_item_id(id)
    @invoice_items.values.find_all do |item|
      item.item_id == id
    end
  end

  def find_all_by_invoice_id(id)
    @invoice_id[id]
  end

  def create_new_id
    all.map do |item|
      item.id
    end.max + 1
  end

  def create(attributes)
    attributes[:id] = create_new_id
    attributes[:created_at] = Time.now.strftime('%F')
    attributes[:updated_at] = Time.now.strftime('%F')
    @invoice_items[attributes[:id]] = InvoiceItem.new(attributes, self)
  end

  def update(id, attributes)
    return nil if find_by_id(id).nil?
    to_update = find_by_id(id)
    price = :unit_price
    to_update.update_updated_at
    to_update.update_quantity(attributes[:quantity]) if attributes[:quantity]
    to_update.update_unit_price(attributes[price]) if attributes[price]
  end

  def delete(id)
    @invoice_items.delete(id)
  end

  def inspect
    "#<#{self.class} #{@invoice_items.size} rows>"
  end
end
