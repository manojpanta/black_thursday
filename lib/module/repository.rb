module Repository
  def find_by_id(id)
    @models.find do |model|
      model.id == id.to_i
    end
  end

  def find_by_name(name)
    @models.find do |model|
      model.name.downcase == name.downcase
    end
  end

  def update(attributes, new_value)
    @attributes = new_value
  end

  def create_new_id
    @models.map do |model|
      model.id
    end.max + 1
  end

  def all
    @models
  end

  def delete(id)
    @models.delete(find_by_id(id))
  end
end
