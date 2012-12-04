class Perspective < ActiveResource::Base
  # To change this template use File | Settings | File Templates.

  self.site = BLACKWOOD_CONFIG['base_host']
  self.prefix = "/publishers/:publisher_id/publisher_categories/:cat/"

  Perspective::User = User
  Perspective::Photo = Picture

  def self.query_near_for_user(username, category, lat, lng)
    Perspective.find(:all, :params => {:publisher_id => username, :cat => category , :lat => lat, :lng => lng} )
  end


  def self.for_user_and_place( username, place_id )
    place = Place.find_for_user(place_id,  username )

    perspective = place.referring_perspectives.first
    perspective.place = place

    return perspective

  end


  def as_json( context)
    #this is necessary to prevent the double nesting that seems to happen with activeresource as_json default calls
    attributes = self.attributes
    attributes = attributes.merge( self.place.as_json )

    return attributes
  end
end