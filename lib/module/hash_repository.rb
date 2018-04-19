module HashRepository
  def find_by_id(id)
    @models[id]
  end

  def find_by_name(name)
    all.find do |model|
      model.name.downcase == name.downcase
    end
  end

  def create_new_id
    all.map do |model|
      model.id
    end.max + 1
  end

  def all
    @models.values
  end

  def delete(id)
    @models.delete(id)
  end

  def find_all_by_invoice_id(id)
    @invoice_ids[id]
  end
end

# require_relative './module/hash_repository'
# include HashRepository
