class User < ActiveResource::Base
  include CachedResource

  User::Picture = Picture
  User::Perspective = Perspective
  User::Perspective::Place = Place

  self.site = BLACKWOOD_CONFIG['base_host']

  def publisher
    @publisher ||= Publisher.find( self.publisher_id )
  end
end