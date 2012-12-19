class Publisher < ActiveResource::Base
  include CachedResource

  self.site = BLACKWOOD_CONFIG['base_host']

  class PublisherCategory < ActiveResource::Base
    self.site = BLACKWOOD_CONFIG['base_host']

    liquid_methods :name, :slug, :description, :image_url, :thumb_url
  end

  liquid_methods :publisher_categories
  attr_reader :domain

  def category_for(category)
    return self.publisher_categories.find {| cat | cat.slug == category }
  end


end