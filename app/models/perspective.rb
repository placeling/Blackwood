class Perspective < ActiveResource::Base
  # To change this template use File | Settings | File Templates.

  self.site = "http://localhost:3000"
  self.prefix = "/users/:user_id/"


  def self.query_near_for_user(user, lat, lng, tags)

    Perspective.find(:all, :params => { :user_id => user.username, :lat => lat, :lng => lng } )
  end


  def self.for_user_and_place( username, place_id )
    place = Place.find(place_id, :params => { :rf => username } )

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