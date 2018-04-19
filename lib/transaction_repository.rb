require'csv'
require_relative 'transaction'
require_relative './module/hash_repository'
# this is transaction repo
class TransactionRepository
  include HashRepository

  def initialize(path, sales_engine)
    @sales_engine   = sales_engine
    @models         = {}
    @invoice_ids    = Hash.new { |h, k| h[k] = [] }
    load_path(path)
  end

  def load_path(path)
    CSV.foreach(path, headers: true, header_converters: :symbol) do |data|
      transaction = Transaction.new(data, self)
      @models[transaction.id] = transaction
      @invoice_ids[transaction.invoice_id] << transaction
    end
  end

  def find_all_by_credit_card_number(card_number)
    all.find_all do |transaction|
      transaction.credit_card_number == card_number
    end
  end

  def find_all_by_result(result)
    all.find_all do |transaction|
      transaction.result == result
    end
  end

  def create(attributes)
    attributes[:id] = create_new_id
    attributes[:created_at] = Time.now.strftime('%F')
    attributes[:updated_at] = Time.now.strftime('%F')
    @models[attributes[:id]] = Transaction.new(attributes, self)
  end

  def update(id, attributes)
    ccn = :credit_card_number
    cce = :credit_card_expiration_date
    return nil if find_by_id(id).nil?
    find = find_by_id(id)
    find.update_updated_at
    find.update_credit_card_number(attributes[ccn]) if attributes[ccn]
    find.update_credit_card_expiration_date(attributes[cce]) if attributes[cce]
    find.update_result(attributes[:result]) if attributes[:result]
  end

  def find_invoice_for_a_transaction(invoice_id)
    @sales_engine.find_invoice_for_a_transaction(invoice_id)
  end

  def inspect
    "#<#{self.class} #{@models.size} rows>"
  end
end
