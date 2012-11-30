class User < ActiveResource::Base
  include CachedResource

  self.site = BLACKWOOD_CONFIG['base_host']

  def publisher
    @publisher ||= Publisher.find( self.publisher_id )
  end
end