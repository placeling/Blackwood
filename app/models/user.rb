class User < ActiveResource::Base
  # To change this template use File | Settings | File Templates.

  self.site = "http://localhost:3000"


  def publisher
    @publisher ||= Publisher.find( self.publisher_id )
  end
end