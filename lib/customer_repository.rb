require 'csv'
require 'time'
require 'date'
require_relative 'customer'
require_relative './module/repository'
# this is model repository
class CustomerRepository
  include Repository
  attr_reader :path,
              :models,
              :sales_engine

  def initialize(path, sales_engine)
    @models       = []
    @path         = path
    @sales_engine = sales_engine
    load_path(path)
  end

  def load_path(path)
    CSV.foreach(path, headers: true, header_converters: :symbol) do |data|
      @models << Customer.new(data, self)
    end
  end

  def find_all_by_first_name(name)
    @models.find_all do |model|
      model.first_name.downcase.include?(name.downcase)
    end
  end

  def find_all_by_last_name(name)
    @models.find_all do |model|
      model.last_name.downcase.include?(name.downcase)
    end
  end

  def create(attribute)
    attribute[:id] = create_new_id
    attribute[:created_at] = Time.now.utc.to_s
    attribute[:updated_at] = Time.now.utc.to_s
    @models << Customer.new(attribute, self)
  end

  def update(id, attribute)
    return nil if find_by_id(id).nil?
    model = find_by_id(id)
    model.update_updated_time
    model.update_first_name(attribute[:first_name]) if attribute[:first_name]
    model.update_last_name(attribute[:last_name]) if attribute[:last_name]
  end


  def inspect
    "#<#{self.class} #{@models.size} rows>"
  end
end
