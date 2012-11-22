class Place < ActiveResource::Base
  # To change this template use File | Settings | File Templates.

  self.site = BLACKWOOD_CONFIG['base_host']

  def self.find_for_user(place_id, username )
    Place.find(place_id, :params => { :rf => username })
  end

end