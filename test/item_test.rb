require_relative 'test_helper'
require 'bigdecimal'
require_relative '../lib/item'

class TestItem < Minitest::Test
  def test_exists
    item = Item.new({ :id => 12394049,
                      :name => "Pencil",
                      :description => "Writes stuff",
                      :unit_price => 45,
                      :created_at => Time.now.to_s,
                      :updated_at => Time.now.to_s }, nil)

      assert_instance_of Item, item
  end

  def test_attributes
    item = Item.new({ :id => 12394049,
                      :name => "Pencil",
                      :description => "Writes stuff",
                      :unit_price => 45,
                      :created_at => Time.now.to_s,
                      :updated_at => Time.now.to_s }, nil)

    assert_equal 12394049, item.id
    assert_equal "Pencil", item.name
    assert_equal "Writes stuff", item.description
    assert_equal 0.45, item.unit_price
    assert_equal 0.45, item.unit_price_to_dollars
    assert_equal Time.parse(Time.now.to_s), item.updated_at
    assert_equal Time.parse(Time.now.to_s), item.created_at
  end

end
