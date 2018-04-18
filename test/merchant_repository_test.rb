require_relative 'test_helper'
require './lib/merchant_repository'
require './lib/sales_engine'
# this is merchant reoi test
class MerchantRepositoryTest< MiniTest::Test
  def test_it_exists
    merchant_repo = MerchantRepository.new('./data/merchants.csv', nil)
    assert_instance_of MerchantRepository, merchant_repo
  end

  def test_merchants_is_a_array
    merchant_repo = MerchantRepository.new('./data/merchants.csv', nil)
    assert_instance_of Array, merchant_repo.all
  end

  def test_it_can_load_all_data
    merchant_repo = MerchantRepository.new('./data/merchants.csv', nil)
    assert_equal 475, merchant_repo.all.count
    assert merchant_repo.all.all? {|merchant| merchant.kind_of?(Merchant)}
    assert_equal 'Shopin1901', merchant_repo.all.first.name
    assert_equal 12334105, merchant_repo.all.first.id
  end

  def test_all_method_returns_all_merchants
    merchant_repo = MerchantRepository.new('./data/merchants.csv', nil)

    assert_equal 475, merchant_repo.all.count
    assert_instance_of Merchant, merchant_repo.all.first
  end

  def test_it_can_load_all_data
    merchant_repo = MerchantRepository.new('./data/merchants.csv', nil)
    assert_equal 475, merchant_repo.all.count
    assert merchant_repo.all.all? {|merchant|merchant.kind_of?(Merchant)}
    assert_equal 'Shopin1901', merchant_repo.all.first.name
    assert_equal 12334105, merchant_repo.all.first.id
  end

  def test_it_can_find_by_id
    merchant_repo = MerchantRepository.new('./data/merchants.csv', nil)

    result = merchant_repo.find_by_id(12334145)

    assert_instance_of Merchant, result
    assert_equal 'BowlsByChris', result.name
    assert_equal 12334145, result.id
  end

  def test_it_can_find_by_id_for_different_id
    merchant_repo = MerchantRepository.new('./data/merchants.csv', nil)

    result = merchant_repo.find_by_id(12334159)

    assert_instance_of Merchant, result
    assert_equal 'SassyStrangeArt', result.name
    assert_equal 12334159, result.id
  end

  def test_it_gives_a_nil_value_when_no_id_matched
    merchant_repo = MerchantRepository.new('./data/merchants.csv', nil)

    result = merchant_repo.find_by_id(00000000)

    assert_nil result
  end

  def test_we_can_find_by_name
    merchant_repo = MerchantRepository.new('./data/merchants.csv', nil)

    result = merchant_repo.find_by_name('princessfrankknits')

    assert_instance_of Merchant, result
    assert_equal 'Princessfrankknits', result.name
    assert_equal 12334234, result.id
  end

  def test_it_gives_a_nil_value_when_no_name_matched
    merchant_repo = MerchantRepository.new('./data/merchants.csv', nil)

    result = merchant_repo.find_by_id('manoj')

    assert_nil result
  end

  def test_it_gives_all_names_matched_with_find_all
    merchant_repo = MerchantRepository.new('./test/fixtures/merchants.csv', nil)

    result = merchant_repo.find_all_by_name('Walmart')

    assert_equal 0, result.count
    assert_nil result.first
    assert_nil result[1]
  end

  def test_it_can_create_a_new_merchant
    merchant_repo = MerchantRepository.new('./test/fixtures/merchants.csv', nil)

    merchant_repo.create({:name => 'manoj'})
    assert_equal 'manoj', merchant_repo.all.last.name
    assert_equal 12337412, merchant_repo.all.last.id

    merchant_repo.create({:name => 'tylor'})
    assert_equal 'tylor', merchant_repo.all.last.name
    assert_equal 12337413, merchant_repo.all.last.id
  end

  def test_it_can_create_a_new_merchant_for_next_one
    merchant_repo = MerchantRepository.new('./test/fixtures/merchants.csv', nil)

    merchant_repo.create({:name => 'tylor'})
    assert_equal 'tylor', merchant_repo.all.last.name
    assert_equal 12337412, merchant_repo.all.last.id
  end

  def test_it_can_update_merchant_with_attributes
    merchant_repo = MerchantRepository.new('./test/fixtures/merchants.csv', nil)
    result1 = merchant_repo.find_by_id(12334141)
    assert_equal 'jejum', result1.name

    merchant_repo.update(12334141, {name: 'walmartinnepal'})
    result = merchant_repo.find_by_id(12334141)

    assert_equal 'walmartinnepal', result.name
  end

  def test_it_can_update_merchant_with_attributes_for_diff_merchant
    merchant_repo = MerchantRepository.new('./test/fixtures/merchants.csv', nil)
    result1 = merchant_repo.find_by_id(12334132)
    assert_equal 'perlesemoi', result1.name

    merchant_repo.update(12334132, {name: 'kingsooper'})
    result = merchant_repo.find_by_id(12334132)

    assert_equal 'kingsooper', result.name
  end

  def test_it_can_delete_merchants_from_the_list
    merchant_repo = MerchantRepository.new('./test/fixtures/merchants.csv', nil)
    assert_equal 475, merchant_repo.all.count

    result1 = merchant_repo.delete(12334132)
    assert_equal 'perlesemoi', result1.name
    assert_equal 12334132, result1.id
    assert_equal 474, merchant_repo.all.count
  end

  def test_it_can_delete_merchants_from_the_list_for_diff_id
    merchant_repo = MerchantRepository.new('./test/fixtures/merchants.csv', nil)
    assert_equal 475, merchant_repo.all.count

    result1 = merchant_repo.delete(12334141)
    assert_equal 'jejum', result1.name
    assert_equal 12334141, result1.id
    assert_equal 474, merchant_repo.all.count
  end

  def test_it_can_find_customers_for_merchant
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
    merchant_repo = MerchantRepository.new('./data/merchants.csv', se)
    result = merchant_repo.all.first.customers
    assert_equal 'Casimer', result.first.first_name
  end
end
