module MapFilters


  def resize(input, arguments)
    return input.gsub("size=100x100", "size=#{ arguments }")
  end

  def terrainmap(input)
    return input += "&maptype=terrain"
  end

end