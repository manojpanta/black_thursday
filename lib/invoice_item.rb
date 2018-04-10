require 'time'

class InvoiceItem
  attr_reader :id,
              :item,
              :invoice_id,
              :quantity,
              :unit_price,
              :created_at,
              :updated_at

  def initialize(data)
    @id = data[:id].to_i
    @item = data[:item]
    @invoice_id = data[:invoice_id]
    @quantity = data[:quantity]
    @unit_price = data[:unit_price]
    @created_at = Time.parse(data[:created_at])
    @updated_at = Time.parse(data[:updated_at])
  end

  def unit_price_to_dollars
    @unit_price.to_f
  end

end
