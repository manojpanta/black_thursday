require_relative 'test_helper'
require './lib/invoice'
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
end
