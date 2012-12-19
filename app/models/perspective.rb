class Perspective < ActiveResource::Base
  include ActionView::Helpers::NumberHelper
  # To change this template use File | Settings | File Templates.

  liquid_methods :name, :slug, :tags, :distance, :street_address

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

  #want the object seen at liquid level to be flat
  def name
    self.place.name
  end

  def slug
    self.place.slug
  end

  def street_address
    self.place.street_address
  end

  def tags
    return self.attributes['tags'].join(", ")
  end

  def distance
    if self.attributes['distance']
      dist = self.attributes['distance'].to_f

      if dist > 0.5
        return "#{number_with_precision( dist, :precision => 1 )}km"
      else
        return "#{number_with_precision( dist*1000, :precision => 0 )}m"
      end

    else
      return ""
    end

  end

  def as_json( context={} )
    #this is necessary to prevent the double nesting that seems to happen with activeresource as_json default calls
    attributes = self.attributes
    attributes = attributes.merge( self.place.as_json )

    return attributes
  end
end