require'csv'
require_relative 'transaction'

class TransactionRepository
  attr_reader :transactions,
              :path,
              :sales_engine

  def initialize(path, sales_engine)
    @path = path
    @sales_engine ||= sales_engine
    @transactions = {}
    @invoice_ids = Hash.new{|h, k| h[k] = []}
    load_path(path)
  end

  def all
    @transactions.values
  end

  def load_path(path)
    CSV.foreach(path, headers: true, header_converters: :symbol) do |data|
      transaction = Transaction.new(data, self)
      @transactions[transaction.id] = transaction
      @invoice_ids[transaction.invoice_id] << transaction
    end
  end

  def find_by_id(id)
    @transactions[id]
  end

  def find_all_by_invoice_id(id)
    @invoice_ids[id]
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

  def create_new_id
    all.map do |transaction|
      transaction.id
    end.max + 1
  end

  def create(attributes)
    attributes[:id] = create_new_id
    attributes[:created_at] = Time.now.strftime('%F')
    attributes[:updated_at] = Time.now.strftime('%F')
    @transactions[attributes[:id]] = Transaction.new(attributes, self)
  end

  def update(id, attributes)
    return nil if find_by_id(id).nil?
    to_update = find_by_id(id)
    to_update.update_updated_at
    to_update.update_credit_card_number(attributes[:credit_card_number]) if attributes[:credit_card_number]
    to_update.update_credit_card_expiration_date(attributes[:credit_card_expiration_date]) if attributes[:credit_card_expiration_date]
    to_update.update_result(attributes[:result]) if attributes[:result]
  end

  def delete(id)
    @transactions.delete(id)
  end

  def find_invoice_for_a_transaction(invoice_id)
    sales_engine.find_invoice_for_a_transaction(invoice_id)
  end

  def inspect
    "#<#{self.class} #{@transactions.size} rows>"
  end
end
