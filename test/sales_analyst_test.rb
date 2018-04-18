require_relative 'test_helper'
require_relative '../lib/sales_analyst'
require_relative '../lib/merchant_repository'
# this is sales analyst test
class SalesAnalystTest < Minitest::Test
  def test_exists
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })

    sales_analyst = SalesAnalyst.new(se)

    assert_instance_of SalesAnalyst, sales_analyst
  end

  def test_if_it_has_merchant_repo
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })

    sales_analyst = SalesAnalyst.new(se)
    assert_instance_of MerchantRepository, sales_analyst.sales_engine.merchants
    assert_equal 'Shopin1901', sales_analyst.sales_engine.merchants.all.first.name
    assert_equal 12334105, sales_analyst.sales_engine.merchants.all.first.id
  end

  def test_if_it_has_items_repo
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })

    sales_analyst = SalesAnalyst.new(se)

    assert_instance_of ItemRepository, sales_analyst.sales_engine.items
    expected = sales_analyst.sales_engine.items.all.first

    assert_instance_of Item, expected
    assert_equal '510+ RealPush Icon Set', expected.name
    assert_equal 263395237, expected.id
  end

  def test_if_it_has_invoice_repo
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })

    sales_analyst = SalesAnalyst.new(se)

    assert_instance_of InvoiceRepository, sales_analyst.sales_engine.invoices
    expected = sales_analyst.sales_engine.invoices.all.first

    assert_instance_of Invoice, expected
    assert_equal 1, expected.id
  end

  def test_if_it_has_invoice_item_repo
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })

    sales_analyst = SalesAnalyst.new(se)

    assert_instance_of InvoiceItemRepository, sales_analyst.sales_engine.invoice_items
    expected = sales_analyst.sales_engine.invoice_items.all.first

    assert_instance_of InvoiceItem, expected
    assert_equal 1, expected.id
  end

  def test_if_it_has_transaction_repo
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })

    sales_analyst = SalesAnalyst.new(se)

    assert_instance_of TransactionRepository, sales_analyst.sales_engine.transactions
    expected = sales_analyst.sales_engine.transactions.all.first

    assert_instance_of Transaction, expected
    assert_equal 1, expected.id
  end

  def test_if_it_has_customer_repo
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })

    sales_analyst = SalesAnalyst.new(se)

    assert_instance_of CustomerRepository, sales_analyst.sales_engine.customers
    expected = sales_analyst.sales_engine.customers.all.first

    assert_instance_of Customer, expected
    assert_equal 1, expected.id
  end

  def test_sales_analyst_can_find_total_no_of_items_in_item_repo
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
    sales_analyst = SalesAnalyst.new(se)

    assert_equal 1367, sales_analyst.sales_engine.items.all.count
  end

  def test_sales_analyst_finds_total_no_of_items_in_item_repo
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
    sales_analyst = SalesAnalyst.new(se)

    assert_equal 475, sales_analyst.sales_engine.merchants.all.count
  end

  def test_it_can_find_average_items_per_merchants
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
    sales_analyst = SalesAnalyst.new(se)

    assert_equal 2.88, sales_analyst.average_items_per_merchant
  end

  def test_it_can_count_calculate_average_items_per_merchant_standard_deviation
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
    sales_analyst = SalesAnalyst.new(se)
    expected = sales_analyst.average_items_per_merchant_standard_deviation

    assert_equal 3.26, expected
  end

  def test_it_can_calculate_merchants_with_high_item_count
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
    sales_analyst = SalesAnalyst.new(se)

    assert_equal 52, sales_analyst.merchants_with_high_item_count.count
  end

  def test_it_can_calculate_average_item_price_for_merchant
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
    sales_analyst = SalesAnalyst.new(se)

    assert_equal 16.66, sales_analyst.average_item_price_for_merchant(12334105)
  end

  def test_it_can_calculate_average_average_price_per_merchant
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
    sales_analyst = SalesAnalyst.new(se)

    assert_equal 350.29, sales_analyst.average_average_price_per_merchant
  end

  def test_it_can_find_average_price_of_items
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
    sales_analyst = SalesAnalyst.new(se)

    assert_equal 251.06, sales_analyst.average_price_of_items
  end

  def test_it_can_find_standard_deviation_for_item_price
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
    sales_analyst = SalesAnalyst.new(se)

    assert_equal 2900.99, sales_analyst.standard_deviation_for_item_price
  end

  def test_it_can_find_golden_items
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
    sales_analyst = SalesAnalyst.new(se)

    assert_equal 5, sales_analyst.golden_items.count
  end

  def test_it_can_calculate_average_invoices_per_merchant
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })

    sales_analyst = SalesAnalyst.new(se)

    assert_equal 10.49, sales_analyst.average_invoices_per_merchant
  end

  def test_it_can_calculate_average_invoices_per_merchant_standard_deviation
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
    sales_analyst = SalesAnalyst.new(se)
    expected = sales_analyst.average_invoices_per_merchant_standard_deviation

    assert_equal 3.29, expected
  end

  def test_it_can_calculate_top_merchants_by_invoice_count
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
    sales_analyst = SalesAnalyst.new(se)

    assert_equal 12, sales_analyst.top_merchants_by_invoice_count.count
  end

  def test_it_can_calculate_bottom_merchants_by_invoice_count
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
    sales_analyst = SalesAnalyst.new(se)

    assert_equal 4, sales_analyst.bottom_merchants_by_invoice_count.count
    assert_equal 7, sales_analyst.organize_invoices_by_days_of_the_week.count
    assert_equal 18.06, sales_analyst.stddv_for_invoices
  end

  def test_it_can_find_top_days_by_invoice_count
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
      sales_analyst = SalesAnalyst.new(se)

    assert_equal 'Wednesday', sales_analyst.top_days_by_invoice_count.first
  end

  def test_it_can_find_percentage_of_each_status
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
    sales_analyst = SalesAnalyst.new(se)

    assert_equal 29.55, sales_analyst.invoice_status(:pending)
    assert_equal 56.95, sales_analyst.invoice_status(:shipped)
    assert_equal 13.5, sales_analyst.invoice_status(:returned)
  end

  def test_if_it_can_check_if_invoice_paid_in_full
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
    sales_analyst = SalesAnalyst.new(se)

    assert_equal true, sales_analyst.invoice_paid_in_full?(2179)
  end

  def test_if_it_can_check_if_invoice_not_paid_in_full
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
    sales_analyst = SalesAnalyst.new(se)

    assert_equal false, sales_analyst.invoice_paid_in_full?(4703)
  end

  def test_if_invoice_id_returns_invoice_total
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
    sales_analyst = SalesAnalyst.new(se)

    assert_equal 21067.77, sales_analyst.invoice_total(1)
  end

  def test_it_can_calculate_total_revenue_by_date
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
    sales_analyst = SalesAnalyst.new(se)
    expected = sales_analyst.total_revenue_by_date(Time.parse('2009-02-07'))
    assert_equal 21067.77, expected
  end

  def test_returns_top_revenue_earner_merchants
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
    sales_analyst = SalesAnalyst.new(se)

    assert_equal 10, sales_analyst.top_revenue_earners(10).count
  end

  def test_it_can_return_merchants_with_pending_invoices
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
    sales_analyst = SalesAnalyst.new(se)

    assert_equal 467, sales_analyst.merchants_with_pending_invoices.count
  end

  def test_it_can_find_merchant_with_ony_one_item
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
    sales_analyst = SalesAnalyst.new(se)
    assert_equal 243, sales_analyst.merchants_with_only_one_item.length
  end

  def test_it_can_find_merchants_with_only_one_item_registered_in_month
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
    sa = SalesAnalyst.new(se)
    result = sa.merchants_with_only_one_item_registered_in_month('May').count

    assert_equal 24, result
  end

  def test_it_can_calculate_total_revenue_for_a_merchant
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
    sales_analyst = SalesAnalyst.new(se)
    assert_equal 81572.4, sales_analyst.revenue_by_merchant(12334194).to_f
  end

  def test_it_can_return_most_sold_item_for_merchant
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
    sales_analyst = SalesAnalyst.new(se)
    result = sales_analyst.most_sold_item_for_merchant(12335150)
    assert_equal 'Take me Home', result.first.name
  end

  def test_it_can_return_best_item_for_a_merchant
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
    sales_analyst = SalesAnalyst.new(se)
    result = sales_analyst.best_item_for_merchant(12335150)
    assert_equal 'Florida Everglades Trash Art', result.name
  end

  def test_it_returns_best_item_for_a_merchant
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })

    sales_analyst = SalesAnalyst.new(se)
    result = sales_analyst.best_item_for_merchant(12335150)
    assert_equal 'Florida Everglades Trash Art', result.name
  end
end
