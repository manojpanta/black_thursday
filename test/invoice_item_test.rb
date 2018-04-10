require 'minitest/autorun'
require 'minitest/pride'
require './lib/invoice_item'
require 'time'

class InvoiceItemTest < Minitest::Test

  def test_exists
    ii = InvoiceItem.new({:id => 1,
                          :item_id => 263519844,
                          :invoice_id => 1,
                          :quantity => 5,
                          :unit_price => 13635
                          :created_at => Time.now,
                          :updated_at => Time.now
                          })

      assert_instance_of InvoiceItem, ii
    # assert_instance_of Time, ii.created_at
    # assert_instance_of Time, ii.updated_at
  end

end
