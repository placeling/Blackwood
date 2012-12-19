class FetchPublishers
  @queue = :chatham_connect

  def self.perform()

    ['gridto', 'georgiastraight'].each do |username|
      user = User.invalidate_cache( username )
      Publisher.invalidate_cache( user.publisher_id ) unless user.nil?

      user = User.find( username )
      Publisher.find( user.publisher_id )
    end

  end

end