require 'time'
require_relative'./module/repository'
# this is customer class
class Customer
  include Repository
  attr_reader :id,
              :first_name,
              :last_name,
              :created_at,
              :updated_at,
              :customer_repo

  def initialize(data, customer_repo)
    @id         = data[:id].to_i
    @first_name = data[:first_name].to_s
    @last_name  = data[:last_name].to_s
    @created_at = Time.parse(data[:created_at])
    @updated_at = Time.parse(data[:updated_at])
    @customer_repo = customer_repo
  end

  def update_updated_time
    @updated_at = Time.now
  end

  def update_first_name(first_name)
    @first_name = first_name
  end

  def update_last_name(name)
    @last_name = name
  end
end
