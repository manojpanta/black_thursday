require_relative 'test_helper'
require './lib/invoice'
require './lib/sales_engine'
# this is invoice test
class InvoiceTest < Minitest::Test
  def test_exists
    invoice = Invoice.new({ :id => 6,
                            :customer_id => 7,
                            :merchant_id => 8,
                            :status      => 'pending',
                            :created_at  => Time.now.to_s,
                            :updated_at  => Time.now.to_s }, nil)

    assert_instance_of Invoice, invoice
  end

  def test_it_returns_intialized_state
    invoice = Invoice.new({ :id => 6,
                            :customer_id => 7,
                            :merchant_id => 8,
                            :status      => 'pending',
                            :created_at  => Time.now.to_s,
                            :updated_at  => Time.now.to_s }, nil)

    assert_equal 6, invoice.id
    assert_equal 7, invoice.customer_id
    assert_equal 8, invoice.merchant_id
    assert_equal :pending, invoice.status
    assert_equal Time.parse(Time.now.to_s), invoice.created_at
    assert_equal Time.parse(Time.now.to_s), invoice.updated_at
  end

  def test_it_can_update_status
    invoice = Invoice.new({ :id => 6,
                            :customer_id => 7,
                            :merchant_id => 8,
                            :status      => 'pending',
                            :created_at  => Time.now.to_s,
                            :updated_at  => Time.now.to_s }, nil)

    invoice.update_status('success')
    assert_equal :success, invoice.status
  end

  def test_it_can_find_items_for_a_invoice
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv'
                          })
    invoice = se.invoices.all.first
    assert_instance_of Item, invoice.items.first
    assert_equal 263519844, invoice.items.first.id
  end

  def test_transactions_for_a_invoice
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv'
                          })
    invoice = se.invoices.all.last
    assert_equal [], invoice.transactions
  end

  def test_it_can_find_customer_for_a_invoice
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv'
                          })
    invoice = se.invoices.all.last
    assert_equal "Sylvester", invoice.customer.first_name
  end

  def test_if_invoice_is_paid_in_full?
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv'
                          })
    invoice = se.invoices.all.last
    assert true, invoice.is_paid_in_full?
  end

  def test_it_can_calculate_invoice_total
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv'
                          })
    invoice = se.invoices.all.first

    assert_equal nil, invoice.invoice_total(invoice.id)
  end
end
