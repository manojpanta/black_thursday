require_relative 'test_helper'
require './lib/transaction_repository'
require './lib/sales_engine'
# this is transaction repo test
class TransactionRepositoryTest < Minitest::Test
  def test_exists
    tr = TransactionRepository.new('./test/fixtures/transactions.csv', nil)

    assert_instance_of TransactionRepository, tr
  end

  def test_it_can_load_all_transaction_from_csv
    tr = TransactionRepository.new('./test/fixtures/transactions.csv', nil)

    assert_equal 4985, tr.all.count
    assert_equal 2179, tr.all.first.invoice_id
    assert_equal '4068631943231473', tr.all.first.credit_card_number
    assert_equal '0217', tr.all.first.credit_card_expiration_date
    assert_equal :success, tr.all.first.result
    assert_equal 4985, tr.all.last.id
  end

  def test_it_can_find_by_id
    tr = TransactionRepository.new('./test/fixtures/transactions.csv', nil)

    result = tr.find_by_id(5)

    assert_equal 5, result.id
    assert_equal 3715, result.invoice_id
    assert_equal '4297222478855497', result.credit_card_number
    assert_equal '1215', result.credit_card_expiration_date
    assert_equal :success, result.result
  end

  def test_it_can_find_by_returns_nil_for_invalid_id
    tr = TransactionRepository.new('./test/fixtures/transactions.csv', nil)

    result = tr.find_by_id(000000)

    assert_nil result
  end

  def test_it_can_find_all_transactions_by_invoice_id
    tr = TransactionRepository.new('./test/fixtures/transactions.csv', nil)

    result = tr.find_all_by_invoice_id(46)

    assert_equal 2, result.count
    assert_equal :success, result.first.result
  end

  def test_find_all_returns_empty_array_for_invalid_invoice_id
    tr = TransactionRepository.new('./test/fixtures/transactions.csv', nil)

    result = tr.find_all_by_invoice_id(00000000)
    assert_equal [], result
  end

  def test_it_can_find_all_transactions_by_find_all_by_credit_card_number
    tr = TransactionRepository.new('./test/fixtures/transactions.csv', nil)

    result = tr.find_all_by_credit_card_number(4177816490204479)

    assert_equal 0, result.count
    assert_nil result.first
  end

  def test_find_all_by_credit_card_number_returns_empty_array_for_invalid_number
    tr = TransactionRepository.new('./test/fixtures/transactions.csv', nil)

    result = tr.find_all_by_credit_card_number(0000000000000)

    assert_equal [], result
  end

  def test_it_can_find_all_transactions_by_result
    tr = TransactionRepository.new('./test/fixtures/transactions.csv', nil)

    result = tr.find_all_by_result(:success)
    result1 = tr.find_all_by_result(:failed)

    assert_equal 4158, result.count
    assert_equal 827, result1.count

    result3 = result1.count + result.count

    assert_equal result3, tr.all.count
  end

  def test_it_can_create_new_id
    tr = TransactionRepository.new('./test/fixtures/transactions.csv', nil)

    assert_equal 4985, tr.all.count

    assert_equal 4986, tr.create_new_id
  end

  def test_it_can_create_new_transaction
    tr = TransactionRepository.new('./test/fixtures/transactions.csv', nil)

    assert_nil tr.find_by_id(4986)

    result = tr.create({ :invoice_id => 1,
                         :credit_card_number => 1234567,
                         :credit_card_expiration_date => '0102',
                         :result => 'failed' })

    result1 = tr.find_by_id(4986)

    assert_equal 1, result1.invoice_id
    assert_equal 1234567, result1.credit_card_number
    assert_equal '0102', result1.credit_card_expiration_date
    assert_equal :failed, result1.result
    assert_equal 4986, result1.id
  end


    def test_it_Can_update_transaction
      tr = TransactionRepository.new('./test/fixtures/transactions.csv', nil)

      result = tr.find_by_id(5)

      assert_equal 3715, result.invoice_id
      assert_equal '4297222478855497', result.credit_card_number
      assert_equal '1215', result.credit_card_expiration_date
      assert_equal :success, result.result

      tr.update(5, { :invoice_id => 1,
                     :credit_card_number => 1234567,
                     :credit_card_expiration_date => '0102',
                     :result => 'failed' })

      result1 = tr.find_by_id(5)

      assert_equal 3715, result1.invoice_id
      assert_equal 1234567, result1.credit_card_number
      assert_equal '0102', result1.credit_card_expiration_date
      assert_equal :failed, result1.result
    end

    def test_it_Can_update_only_supplied_attributes_of_a_transaction
      tr = TransactionRepository.new('./test/fixtures/transactions.csv', nil)

      result = tr.find_by_id(5)

      assert_equal :success,result.result

      tr.update(5, { :invoice_id => 1,
                     :credit_card_number => 1234567,
                     :credit_card_expiration_date => '0102' })

      result1 = tr.find_by_id(5)

      assert_equal :success, result1.result
    end

    def test_it_can_delete_transaction
      tr = TransactionRepository.new('./test/fixtures/transactions.csv', nil)

      result = tr.find_by_id(5)

      assert_instance_of Transaction, result

      tr.delete(5)

      assert_nil tr.find_by_id(5)
    end

    def test_it_can_find_invoice_for_a_transaction
      se = SalesEngine.new({:items => './test/fixtures/items.csv',
                            :merchants => './test/fixtures/merchants.csv',
                            :invoices => './test/fixtures/invoices.csv',
                            :invoice_items => './test/fixtures/invoice_items.csv',
                            :transactions => './test/fixtures/transactions.csv',
                            :customers => './test/fixtures/customers.csv'
                            })
      transaction_repo = se.transactions
      trscn = transaction_repo.all.first
      result = transaction_repo.find_invoice_for_a_transaction(trscn.invoice_id)
      assert_equal 2179, result.id
    end
end
