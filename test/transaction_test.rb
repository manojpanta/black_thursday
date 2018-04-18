require_relative 'test_helper'
require './lib/transaction'
require './lib/sales_engine'
# this is transaction test
class TransactionTest < Minitest::Test
  def test_it_exists
    transaction = Transaction.new({ :id => 6,
                                    :invoice_id => 8,
                                    :credit_card_number => '4242424242424242',
                                    :credit_card_expiration_date => '0220',
                                    :result => 'success',
                                    :created_at => Time.now.to_s,
                                    :updated_at => Time.now.to_s }, nil)
    assert_instance_of Transaction, transaction
  end

  def test_it_can_have_attributes
    transaction = Transaction.new({ :id => 6,
                                    :invoice_id => 8,
                                    :credit_card_number => '4242424242424242',
                                    :credit_card_expiration_date => '0220',
                                    :result => 'success',
                                    :created_at => Time.now.to_s,
                                    :updated_at => Time.now.to_s }, nil)
    assert_equal 6, transaction.id
    assert_equal 8, transaction.invoice_id
    assert_equal '4242424242424242', transaction.credit_card_number
    assert_equal '0220', transaction.credit_card_expiration_date
    assert_equal :success, transaction.result
  end

  def test_can_update_attributes
    transaction = Transaction.new({ :id => 6,
                                    :invoice_id => 8,
                                    :credit_card_number => '4242424242424242',
                                    :credit_card_expiration_date => '0220',
                                    :result => 'success',
                                    :created_at => Time.now.to_s,
                                    :updated_at => Time.now.to_s }, nil)

    transaction.update_updated_at
    transaction.update_credit_card_number(123455)
    transaction.update_credit_card_expiration_date('0304')
    transaction.update_result(:pending)

    assert_equal 123455, transaction.credit_card_number
    assert_equal '0304', transaction.credit_card_expiration_date
    assert_equal :pending, transaction.result
  end

  def test_it_can_return_invoice_for_a_transaction
    se = SalesEngine.new({:items => './test/fixtures/items.csv',
                          :merchants => './test/fixtures/merchants.csv',
                          :invoices => './test/fixtures/invoices.csv',
                          :invoice_items => './test/fixtures/invoice_items.csv',
                          :transactions => './test/fixtures/transactions.csv',
                          :customers => './test/fixtures/customers.csv' })
    transaction = se.transactions.all.first
    result = transaction.invoice
    assert_nil result
  end
end
