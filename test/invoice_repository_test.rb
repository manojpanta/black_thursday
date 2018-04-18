require_relative 'test_helper'
require './lib/invoice_repository'
require_relative '../lib/sales_engine'
# this is invoice repo test
class InvoiceRepositoryTest < Minitest::Test
  def test_exists
    ir = InvoiceRepository.new('./test/fixtures/invoices.csv', nil)
    assert_instance_of InvoiceRepository, ir
  end

  def test_it_can_have_path
    ir = InvoiceRepository.new('./test/fixtures/invoices.csv', nil)

    assert_equal './test/fixtures/invoices.csv', ir.path
  end

  def test_invoices_is_a_hash
    ir = InvoiceRepository.new('./test/fixtures/invoices.csv', nil)

    assert_instance_of Hash, ir.invoices
  end

  def test_merchant_ids_hash_has_array_of_invoices_by_merchant_id
    ir = InvoiceRepository.new('./test/fixtures/invoices.csv', nil)

    assert_instance_of Array, ir.merchant_ids.values.first
    assert_equal [], ir.merchant_ids[12334141]
  end

  def test_it_can_load_invoices_from_path_given
    ir = InvoiceRepository.new('./test/fixtures/invoices.csv', nil)

    assert_equal 20, ir.all.count
    assert_equal 12335938, ir.all.first.merchant_id
    assert_equal 1, ir.all.first.id
    assert_equal 1, ir.all.first.customer_id
  end

  def test_all_method_returns_all_invpoices
    ir = InvoiceRepository.new('./test/fixtures/invoices.csv', nil)

    assert_instance_of Array, ir.all
    assert_equal 20, ir.invoices.count
  end

  def test_find_by_id_returns_invoice
    ir = InvoiceRepository.new('./test/fixtures/invoices.csv', nil)

    result = ir.find_by_id(1)

    assert_instance_of Invoice, result
    assert_equal 12335938, result.merchant_id
    assert_equal 1, result.customer_id
    assert_equal :pending, result.status
  end

  def test_returns_nil_if_invoice_id_not_matched
    ir = InvoiceRepository.new('./test/fixtures/invoices.csv', nil)

    result = ir.find_by_id(0)

    assert_nil result
  end

  def test_it_can_find_merchant_for_invoice
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv'
                          })
    ir = InvoiceRepository.new('./test/fixtures/invoices.csv', se)

    assert_instance_of Merchant, ir.all.first.merchant
    assert_equal 'IanLudiBoards', ir.all.first.merchant.name
  end

  def test_it_can_find_all_invoices_by_customer_id
    ir = InvoiceRepository.new('./test/fixtures/invoices.csv', nil)

    result = ir.find_all_by_customer_id(1)

    assert_equal 8, result.count
  end

  def test_it_returns_empty_array_for_invalid_customer_id
    ir = InvoiceRepository.new('./test/fixtures/invoices.csv', nil)

    result = ir.find_all_by_customer_id(0)

    assert_equal [], result
  end

  def test_it_can_find_all_invoices_by_merchant_id
    ir = InvoiceRepository.new('./test/fixtures/invoices.csv', nil)

    result = ir.find_all_by_merchant_id(12335938)

    assert_equal 1, result.count
  end

  def test_it_returns_empty_array_for_invalid_merchant_id
    ir = InvoiceRepository.new('./test/fixtures/invoices.csv', nil)

    result = ir.find_all_by_merchant_id(0)

    assert_equal [], result
  end

  def test_it_can_find_all_invoices_by_status
    ir = InvoiceRepository.new('./test/fixtures/invoices.csv', nil)

    result = ir.find_all_by_status(:pending)

    assert_equal 9, result.count
  end

  def test_it_returns_empty_array_for_invalid_status
    ir = InvoiceRepository.new('./test/fixtures/invoices.csv', nil)

    result = ir.find_all_by_status('0')

    assert_equal [], result
  end

  def test_it_can_create_new_invoice_id
    ir = InvoiceRepository.new('./test/fixtures/invoices.csv', nil)
    assert_equal 20, ir.all.count

    assert_equal 21, ir.create_new_id
  end

  def test_it_can_create_new_invoice_object
    ir = InvoiceRepository.new('./test/fixtures/invoices.csv', nil)
    assert_equal 21, ir.create_new_id

    result = ir.create({ :customer_id => 2,
                         :merchant_id => 3,
                         :status =>  'pending' })
    assert_equal 21, result.id
    assert_equal :pending, result.status
  end

  def test_it_can_update_a_invoice
    ir = InvoiceRepository.new('./test/fixtures/invoices.csv', nil)

    result = ir.find_by_id(1)
    assert_equal :pending, result.status
    assert_equal 12335938, result.merchant_id
    assert_equal 1, result.customer_id

    ir.update(1, {:status => 'shipped', :merchant_id => 4, :customer_id => 7})
    result1 = ir.find_by_id(1)
    assert_equal :shipped, result1.status
    assert_equal 12335938, result1.merchant_id
    assert_equal 1, result1.customer_id
  end

  def test_returns_nil_it_tried_to_update_invalid_invoice
    ir = InvoiceRepository.new('./test/fixtures/invoices.csv', nil)

    assert_nil ir.find_by_id(4986)

    result = ir.update(4986, { :status => 'shipped',
                               :merchant_id => 4,
                               :customer_id => 7 })

    assert_nil result
  end

  def test_it_can_delete_invoices_from_item_repo
    ir = InvoiceRepository.new('./test/fixtures/invoices.csv', nil)
    result = ir.find_by_id(1)

    assert_equal :pending, result.status
    assert_equal 12335938, result.merchant_id
    assert_equal 1, result.customer_id

    ir.delete(1)

    assert_nil ir.find_by_id(1)
  end

  def test_it_can_find_all_invoices_for_a_date
    ir = InvoiceRepository.new('./test/fixtures/invoices.csv', nil)

    assert_equal 1, ir.total_invoices_for_a_date(Time.parse('2009-02-07')).count
  end

  def test_it_finds_all_invoices_for_a_date
    ir = InvoiceRepository.new('./test/fixtures/invoices.csv', nil)

    assert_equal 0, ir.total_invoices_for_a_date('2014-03-15').count
  end

  def test_it_can_find_items_for_invoice
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
    ir = InvoiceRepository.new('./test/fixtures/invoices.csv', se)
    result = ir.all.first.items
    assert_instance_of Item, result.first
    assert_equal 8, result.count
    name = 'Catnip Pillow / Cat Toy Containing Strong Dried CATNIP'
    assert_equal name, result.first.name
  end

  def test_it_can_find_a_customer_for_invoice
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv'
                          })
    ir = InvoiceRepository.new('./test/fixtures/invoices.csv', se)

    result = ir.find_customer_of_a_invoice(1)
    assert_instance_of Customer, result
    assert_equal 1, result.id
  end

  def test_it_can_find_invoice_items_for_a_invoice
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv'
                          })
    ir = InvoiceRepository.new('./test/fixtures/invoices.csv', se)

    result = ir.find_invoice_item_for_a_invoice(1)
    assert_equal 8, result.length
    assert_instance_of InvoiceItem, result.first
  end

  def test_it_can_find_transactions_for_a_invoice
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv'
                          })
    ir = InvoiceRepository.new('./test/fixtures/invoices.csv', se)

    result = ir.find_transactions_for_a_invoice(1)
    assert_equal 0, result.length
    assert_nil result.first
  end

  def test_it_can_find_merchant_for_a_invoice
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv'
                          })
    ir = InvoiceRepository.new('./test/fixtures/invoices.csv', se)

    result = ir.find_merchant_for_a_invoice(12334135)
    assert_instance_of Merchant, result
  end
end
