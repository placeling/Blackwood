class Publisher < ActiveResource::Base
  include CachedResource

  self.site = BLACKWOOD_CONFIG['base_host']

  def category_for(category)
    return self.publisher_categories.find {| cat | cat.slug == category }
  end


end