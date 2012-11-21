class User < ActiveResource::Base
  # To change this template use File | Settings | File Templates.

  self.site = BLACKWOOD_CONFIG['base_host']

  def publisher
    @publisher ||= Publisher.find( self.publisher_id )
  end
end