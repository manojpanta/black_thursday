require 'csv'
require 'time'
require 'date'
require_relative 'item'
require_relative './module/repository'

# this is item repo
class ItemRepository
  include Repository
  attr_reader :items,
              :sales_engine

  def initialize(path, sales_engine)
    @models         = []
    @sales_engine   = sales_engine
    load_path(path)
  end

  def load_path(path)
    CSV.foreach(path, headers: true, header_converters: :symbol) do |data|
      @models << Item.new(data, self)
    end
  end

  def find_all_with_description(description)
    @models.find_all do |model|
      model.description.downcase.include?(description.downcase)
    end
  end

  def find_all_by_price(price)
    @models.find_all do |model|
      model.unit_price == price
    end
  end

  def find_all_by_price_in_range(price_range)
    @models.find_all do |model|
      price_range.include?(model.unit_price)
    end
  end

  def find_all_by_merchant_id(id)
    @models.find_all do |model|
      model.merchant_id == id
    end
  end

  def create(attributes)
    attributes[:id] = create_new_id
    attributes[:created_at] = Time.now.to_s
    attributes[:updated_at] = Time.now.to_s
    @models << Item.new(attributes, self)
    Item.new(attributes, self)
  end

  def update(id, attributes)
    return nil if find_by_id(id).nil?
    model = find_by_id(id)
    model.update_updated_at
    model.update_name(attributes[:name]) if attributes[:name]
    model.update_description(attributes[:description])if attributes[:description]
    model.update_unit_price(attributes[:unit_price]) if attributes[:unit_price]
  end

  def find_merchant_of_a_item(merchant_id)
    sales_engine.find_merchant_of_a_item(merchant_id)
  end

  def inspect
    "#<#{self.class} #{@models.size} rows>"
  end
end
