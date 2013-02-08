
namespace "redis" do

  desc "Subscriber process that listens for cache invalidations"
  task :subscriber => :environment do
    REDIS_CONFIG = YAML.load(File.open(Rails.root.join("config/subscribe_redis.yml")))[Rails.env]

    redis_connect = Redis.new(REDIS_CONFIG.symbolize_keys!.merge(:timeout => 0) )

    #update the publishers actions
    Resque.enqueue( FetchPublishers )

    puts "Subscribing to Invalidations in RAILS_ENV:#{Rails.env}"
    redis_connect.subscribe("#{REDIS_CONFIG[:namespace]}:invalidations") do |on|
      on.message do |channel, msg|
        data = JSON.parse(msg)
        puts "#invalidating key - [#{data['model']}/#{data['id']}]"

        $redis.del( "#{data['model']}/#{data['id']}".downcase )

        if data['publisher']
          Publisher.create_with_cache( data['id'], data['publisher'] )
        end
      end
    end
  end
end

namespace :resque do
  puts "Loading Rails environment for Resque"
  task :setup => :environment do

  end
end