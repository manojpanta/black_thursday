require_relative 'test_helper'
require 'csv'
require_relative '../lib/sales_engine'
# this is salesengine test
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

  def test_from_csv_method
    se = SalesEngine.from_csv({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv'
                          })
    assert_instance_of SalesEngine, se
  end

  def test_find_customers_for_a_merchant
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv'
                          })
    result = se.find_customers_for_a_merchant(10)
    assert_instance_of Customer, result
    assert_equal 'Ramona', result.first_name
  end

  def test_find_merchant_of_an_item
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv'
                          })
    result = se.find_merchant_of_a_item(12334165)
    assert_instance_of Merchant, result
    assert_equal 'JUSTEmonsters', result.name
  end

  def test_find_invoice_for_a_transaction
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv'
                          })
    result = se.find_invoice_for_a_transaction(5)
    assert_instance_of Invoice, result
    assert_equal 5, result.id
  end

  def test_it_can_find_invoices_for_merchant
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv'
                          })
    result = se.invoices_for_merchant(2334105)
    assert_equal [], result
  end

  def test_it_can_find_items_for_merchant
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv'
                          })
    result = se.items_for_a_merchant(2334105)
    assert_equal [], result
  end

  def test_it_can_find_customers_for_merchant
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv'
                          })
    result = se.find_customers_for_a_merchant(1)
    assert_equal "Joey", result.first_name
  end

  def test_it_can_find_merchant_for_invoice
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv'
                          })
    result = se.find_merchant_for_a_invoice(2334105)
    assert_nil result
  end

  def test_it_can_find_merchant_of_an_item
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv'
                          })
    result = se.find_merchant_of_a_item(2334105)
    assert_nil result
  end

  def test_it_can_find_transactions_of_a_invoice
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv'
                          })
    result = se.find_transactions_for_a_invoice(1)
    assert_equal [], result
  end

  def test_it_can_find_customer_of_a_invoice
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv'
                          })
    result = se.find_customer_of_a_invoice(1)
    assert_equal "Joey", result.first_name
  end

  def test_it_can_find_invoice_for_a_transaction
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv'
                          })
    result = se.find_invoice_for_a_transaction(1)
    assert_equal 1, result.id
  end

  def test_it_can_find_invoice_item_for_a_invoice
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv'
                          })
    result = se.find_invoice_item_for_a_invoice(1)
    assert_instance_of InvoiceItem, result.first
    assert_equal 1, result.first.id
  end
end
