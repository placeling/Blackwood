class Publisher < ActiveResource::Base
  include CachedResource

  self.site = BLACKWOOD_CONFIG['base_host']

  class PublisherCategory < ActiveResource::Base
    self.site = BLACKWOOD_CONFIG['base_host']
  end

  attr_reader :footerpng, :wellpng, :domain


  def category_for(category)
    return self.publisher_categories.find {| cat | cat.slug == category }
  end


end