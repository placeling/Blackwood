class Perspective < ActiveResource::Base
  # To change this template use File | Settings | File Templates.

  self.site = "http://localhost:3000"
  self.prefix = "/users/:user_id/"


  def self.query_near_for_user(user, lat, lng, tags)

    Perspective.find(:all, :params => { :user_id => user.username, :lat => lat, :lng => lng } )
  end


end