class Picture < ActiveResource::Base
  # To change this template use File | Settings | File Templates.
  self.site = BLACKWOOD_CONFIG['base_host']

  liquid_methods :main_url, :thumb_url, :square_url


end