require_relative 'sales_engine'
require 'time'
# this is sales analyst class
class SalesAnalyst
  attr_reader :sales_engine
  def initialize(sales_engine)
    @sales_engine       = sales_engine
    @merchant_repo      = sales_engine.merchants
    @item_repo          = sales_engine.items
    @invoice_repo       = sales_engine.invoices
    @invoice_item_repo  = sales_engine.invoice_items
    @transaction_repo   = sales_engine.transactions
    @customer_repo      = sales_engine.customers
  end

  def average_items_per_merchant
    (@item_repo.all.count.to_f / @merchant_repo.all.count).round(2)
  end

  def average_items_per_merchant_standard_deviation
    numbers_of_item = @merchant_repo.all.map do |merchant|
      merchant.items.count
    end
    total = numbers_of_item.reduce(0) do |sum, number|
      sum + (number - average_items_per_merchant) ** 2
    end / (numbers_of_item.count - 1)
    Math.sqrt(total).round(2)
  end

  def merchants_with_high_item_count
    average = average_items_per_merchant
    standard_deviation = average_items_per_merchant_standard_deviation
    one_stddv = average + standard_deviation
    @merchant_repo.all.map do |merchant|
      merchant if merchant.items.count > one_stddv
    end.compact
  end

  def average_item_price_for_merchant(merchant_id)
    merchant = @merchant_repo.find_by_id(merchant_id)
    merchant.items.reduce(0) do |sum, item|
      sum + item.unit_price / merchant.items.length
    end.round(2)
  end

  def average_average_price_per_merchant
    @merchant_repo.all.reduce(0) do |sum, merchant|
      average_price = average_item_price_for_merchant(merchant.id)
      merchants_count = @merchant_repo.all.count
      sum + (average_price / merchants_count)
    end.round(2)
  end

  def average_price_of_items
    @item_repo.all.reduce(0) do |total, item|
      total + item.unit_price / @item_repo.all.count
    end.round(2)
  end

  def standard_deviation_for_item_price
    average_price = average_price_of_items
    total = @item_repo.all.reduce(0) do |sum, item|
      sum + (item.unit_price - average_price) ** 2
    end / (@item_repo.all.count - 1)
    Math.sqrt(total).round(2)
  end

  def golden_items
    twostdv = average_price_of_items + (standard_deviation_for_item_price * 2)
    @item_repo.all.map do |item|
      item if item.unit_price > twostdv
    end.compact
  end

  def average_invoices_per_merchant
    numbers_of_invoices = @invoice_repo.all.count
    numbers_of_merchants = @invoice_repo.all.map do |invoice|
      invoice.merchant_id
    end.uniq.count
    (numbers_of_invoices.to_f / numbers_of_merchants).round(2)
  end

  def average_invoices_per_merchant_standard_deviation
    average = average_invoices_per_merchant
    numbers_of_merchants = @merchant_repo.all.count
    total = @merchant_repo.all.reduce(0) do |sum, merchant|
      sum + (merchant.invoices.count - average) ** 2
    end / (numbers_of_merchants - 1)
    Math.sqrt(total).round(2)
  end

  def top_merchants_by_invoice_count
    average_double = (average_invoices_per_merchant_standard_deviation * 2)
    two_standard_deviation = average_invoices_per_merchant + average_double
    @merchant_repo.all.map do |merchant|
      merchant if merchant.invoices.count > two_standard_deviation
    end.compact
  end

  def bottom_merchants_by_invoice_count
    average_double = (average_invoices_per_merchant_standard_deviation * 2)
    two_standard_deviation = average_invoices_per_merchant - average_double
    @merchant_repo.all.map do |merchant|
      merchant if merchant.invoices.count < two_standard_deviation
    end.compact
  end

  def average_number_of_invoices_per_day
    @invoice_repo.all.count / 7
  end

  def organize_invoices_by_days_of_the_week
    @invoice_repo.all.group_by do |invoice|
      invoice.created_at.strftime('%A')
    end
  end

  def stddv_for_invoices
    total = organize_invoices_by_days_of_the_week.reduce(0) do |sum, (key, value)|
      sum + (value.count - average_number_of_invoices_per_day) ** 2
    end / 6
    Math.sqrt(total).round(2)
  end

  def top_days_by_invoice_count
    one_stddv = average_number_of_invoices_per_day + stddv_for_invoices
    organize_invoices_by_days_of_the_week.each_pair.map do |key, value|
      key if value.count > one_stddv
    end.compact.sort.reverse
  end

  def invoice_status(status)
    total_invoices = @invoice_repo.all.count
    invoices = @invoice_repo.all.map do |invoice|
      invoice if invoice.status == status
    end.compact.count
    ((invoices.to_f / total_invoices) * 100).round(2)
  end

  def invoice_paid_in_full?(invoice_id)
    @transaction_repo.find_all_by_invoice_id(invoice_id).any? do |transaction|
      transaction.result == :success
    end
  end

  def invoice_total(invoice_id)
    @invoice_item_repo.find_all_by_invoice_id(invoice_id).reduce(0) do |sum, iit|
      sum + (iit.quantity * iit.unit_price)
    end
  end

  def total_revenue_by_date(date)
    invoices = @invoice_repo.total_invoices_for_a_date(date)
    invoices.reduce(0) do |total, invoice|
      total + invoice_total(invoice.id)
    end
  end

  def merchants_ranked_by_revenue
    @merchant_repo.all.sort_by do |merchant|
      merchant.revenue
    end.reverse
  end

  def top_revenue_earners(number = 20)
    merchants_ranked_by_revenue[0..(number - 1)]
  end

  def merchants_with_pending_invoices
    @invoice_repo.all.map do |invoice|
      unless invoice.is_paid_in_full?
        @merchant_repo.find_by_id(invoice.merchant_id)
      end
    end.compact.uniq
  end

  def merchants_with_only_one_item
    @merchant_repo.all.map do |merchant|
      merchant if merchant.items.count == 1
    end.compact
  end

  def merchants_with_only_one_item_registered_in_month(month)
    merchants_by_month = merchants_with_only_one_item.group_by do |merchant|
      Time.parse(merchant.created_at).strftime('%B')
    end
    merchants_by_month[month]
  end

  def revenue_by_merchant(merchant_id)
    @merchant_repo.find_by_id(merchant_id).revenue
  end

  def invoice_items_for_a_merchant(merchant_id)
    merchant_invoices = @merchant_repo.find_by_id(merchant_id).invoices
    merchant_invoices.map do |invoice|
      if invoice.is_paid_in_full?
        @invoice_item_repo.find_all_by_invoice_id(invoice.id)
      end
    end.flatten.compact
  end

  def sort_invoice_items_by_quantity(merchant_id)
    invoice_items_for_a_merchant(merchant_id).sort_by do |invoice_item|
      invoice_item.quantity
    end.reverse
  end

  def most_sold_item_for_merchant(merchant_id)
    winner = sort_invoice_items_by_quantity(merchant_id)[0].quantity
    sort_invoice_items_by_quantity(merchant_id).delete_if do |invoice|
      invoice.quantity != winner
    end.map do |invoice_item|
      @item_repo.find_by_id(invoice_item.item_id)
    end
  end

  def best_item_for_merchant(merchant_id)
    iitem = invoice_items_for_a_merchant(merchant_id).sort_by do |invoice_item|
      invoice_item.revenue_out_of_one_invoice_item
    end.reverse.first
    @item_repo.find_by_id(iitem.item_id)
  end
end
