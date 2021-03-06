require './lib/customer'
require_relative 'test_helper'
# this is customer test
class CustomerTest < MiniTest::Test
  def test_it_exists
    customer = Customer.new({ :id => 1,
                              :first_name => 'tyler',
                              :last_name => 'westlie',
                              :created_at => '2011-04-10',
                              :updated_at => '2014-03-12' }, nil)
    assert_instance_of Customer, customer
  end

  def test_it_can_have_attributes
    customer = Customer.new({ :id => 1,
                              :first_name => 'tyler',
                              :last_name => 'westlie',
                              :created_at => '2011-04-10',
                              :updated_at => '2014-03-12' }, nil)
    assert_equal 1, customer.id
    assert_equal 'tyler', customer.first_name
    assert_equal 'westlie', customer.last_name
    assert_equal Time.parse('2011-04-10'), customer.created_at
    assert_equal Time.parse('2014-03-12'), customer.updated_at
  end
end
