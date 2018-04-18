require_relative 'test_helper'
require './lib/merchant'
require './lib/sales_engine'
# this is merchant test
class MerchantTest < MiniTest::Test
  def test_it_exists
    merchant = Merchant.new({ :id => 5, :name => 'Turing School' }, nil)

    assert_instance_of Merchant, merchant
  end

  def test_merchant_can_have_name_and_id
    merchant = Merchant.new( {:id => 5, :name => 'Turing School' }, nil)

    assert_equal 'Turing School', merchant.name
    assert_equal 5, merchant.id
  end

  def test_merchant_can_have_name_and_id_for_another_merchant
    merchant = Merchant.new({ :id => 3, :name => 'Walmart' }, nil)

    assert_equal 'Walmart', merchant.name
    assert_equal 3, merchant.id
  end

  def test_returns_invoices_for_a_merchant
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv'
                          })
    merchant = se.merchants.all[2]
    result = merchant.invoices
    assert_equal [], result
  end

  def test_returns_merchant_revenue
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv'
                          })
    merchant = se.merchants.all[2]
    result = merchant.revenue
    assert_equal 0, result
  end

  def test_returns_merchant_customers
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv'
                          })
    merchant = se.merchants.all[2]
    result = merchant.customers
    assert_nil result.first
  end

  def test_returns_merchant_items
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv'
                          })
    merchant = se.merchants.all[2]
    result = merchant.items
    assert_equal 1, result.count
  end
end
