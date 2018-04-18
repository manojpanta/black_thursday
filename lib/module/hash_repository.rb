module HashRepository


  def find_by_id(id)
    @models[id]
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
end
