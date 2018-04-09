require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_analyst'

class SalesAnalystTest < Minitest::Test
  def test_exists
    se = SalesEngine.new({:items=> "./test/items.csv",:merchants => "./data/merchants.csv"})

    sales_analyst = SalesAnalyst.new(se)

    assert_instance_of SalesAnalyst, sales_analyst
  end

  def test_it_can_find_average_items_per_merchants
    se = SalesEngine.new({:items=> "./test/items.csv",:merchants => "./data/merchants.csv"})
    sales_analyst = SalesAnalyst.new(se)

    assert_equal 2.88, sales_analyst.average_items_per_merchant
  end

  def test_it_can_find_items_with_merchant_id
    skip
    se = SalesEngine.new({:items=> "./test/items.csv",:merchants => "./data/merchants.csv"})
    sales_analyst = SalesAnalyst.new(se)

    assert_equal 0, sales_analyst.items
  end

  def test_it_can_count_merchant_items
    se = SalesEngine.new({:items=> "./test/items.csv",:merchants => "./data/merchants.csv"})
    sales_analyst = SalesAnalyst.new(se)

    assert_equal 3.26, sales_analyst.average_items_per_merchant_standard_deviation
  end



end
