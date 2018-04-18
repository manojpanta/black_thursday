require 'csv'
require_relative 'invoice_item'
require_relative './module/hash_repository'

# this is invoice repo
class InvoiceItemRepository
  include HashRepository
  attr_reader :invoice_items,
              :invoice_id

  def initialize(path, sales_engine)
    @sales_engine = sales_engine
    @models       = {}
    @invoice_id   = Hash.new { |h, k| h[k] = [] }
    load_path(path)
  end

  def load_path(path)
    CSV.foreach(path, headers: true, header_converters: :symbol) do |data|
      invoice_item = InvoiceItem.new(data, self)
      @models[invoice_item.id] = invoice_item
      @invoice_id[invoice_item.invoice_id] << invoice_item
    end
  end

  def find_all_by_item_id(id)
    @models.values.find_all do |item|
      item.item_id == id
    end
  end

  def find_all_by_invoice_id(id)
    @invoice_id[id]
  end

  def create(attributes)
    attributes[:id] = create_new_id
    attributes[:created_at] = Time.now.strftime('%F')
    attributes[:updated_at] = Time.now.strftime('%F')
    @models[attributes[:id]] = InvoiceItem.new(attributes, self)
  end

  def update(id, attributes)
    return nil if find_by_id(id).nil?
    to_update = find_by_id(id)
    price = :unit_price
    to_update.update_updated_at
    to_update.update_quantity(attributes[:quantity]) if attributes[:quantity]
    to_update.update_unit_price(attributes[price]) if attributes[price]
  end

  def inspect
    "#<#{self.class} #{@models.size} rows>"
  end
end
