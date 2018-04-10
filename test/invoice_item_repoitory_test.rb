require 'minitest/autorun'
require 'minitest/pride'
require './lib/invoice_item_repository'
require 'bigdecimal'
require 'time'

class InvoiceItemRepositoryTest < Minitest::Test
  def test_exists
    invoice_item_repo = InvoiceItemRepository.new

    assert_instance_of InvoiceItemRepository, invoice_item_repo
  end
end
