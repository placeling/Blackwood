class FetchPublishers
  @queue = :chatham_connect

  def self.perform()

    ['gridto', 'georgiastraight'].each do |username|
      user = User.find( username )
      Publisher.find( user.publisher_id )
    end

  end
end