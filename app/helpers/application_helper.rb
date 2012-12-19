require 'liquid/map_filters'
module ApplicationHelper

  def liquidize(content, arguments)
    Liquid::Template.parse(content).render(arguments, :filters => [MapFilters])
  end

end
