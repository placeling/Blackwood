class Place < ActiveResource::Base
  # To change this template use File | Settings | File Templates.

  self.site = BLACKWOOD_CONFIG['base_host']

end