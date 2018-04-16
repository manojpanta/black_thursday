require_relative 'test_helper'
require 'csv'
require_relative '../lib/sales_engine'

class SalesEngineTest<Minitest::Test

  def test_it_exists
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv'
                          })
    assert_instance_of SalesEngine, se
  end

  def test_it_can_create_sales_analyst
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv'
                          })
    sales_analyst = se.analyst

    assert_instance_of SalesAnalyst, sales_analyst
  end
end
