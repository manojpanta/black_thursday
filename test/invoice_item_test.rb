require 'minitest/autorun'
require 'minitest/pride'
require './lib/invoice_item'
require 'bigdecimal'
require 'time'

class InvoiceItemTest < Minitest::Test

  def test_exists
    ii = InvoiceItem.new({:id => 6,
                          :item_id => 7,
                          :invoice_id => 8,
                          :quantity => 1,
                          :unit_price => BigDecimal.new(10.99, 4),
                          :created_at => Time.now,
                          :updated_at => Time.now
                          })

      assert_instance_of InvoiceItem, ii
    # assert_instance_of Time, ii.created_at
    # assert_instance_of Time, ii.updated_at
  end

end
