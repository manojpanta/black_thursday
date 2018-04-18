require_relative 'test_helper'
require 'bigdecimal'
require_relative '../lib/item'
require './lib/sales_engine'
# this is item test
class TestItem < Minitest::Test
  def test_exists
    item = Item.new({ :id => 12394049,
                      :name => 'Pencil',
                      :description => 'Writes stuff',
                      :unit_price => 45,
                      :created_at => Time.now.to_s,
                      :updated_at => Time.now.to_s }, nil)

    assert_instance_of Item, item
  end

  def test_attributes
    item = Item.new({ :id => 12394049,
                      :name => 'Pencil',
                      :description => 'Writes stuff',
                      :unit_price => 45,
                      :created_at => Time.now.to_s,
                      :updated_at => Time.now.to_s }, nil)

    assert_equal 12394049, item.id
    assert_equal 'Pencil', item.name
    assert_equal 'Writes stuff', item.description
    assert_equal 0.45, item.unit_price
    assert_equal 0.45, item.unit_price_to_dollars
    assert_equal Time.parse(Time.now.to_s), item.updated_at
    assert_equal Time.parse(Time.now.to_s), item.created_at
  end

  def test_it_can_find_merchant_for_a_item
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
    item = se.items.items.first
    result = item.merchant
    assert_instance_of Merchant, result
    assert_equal 'jejum', result.name
  end
end
