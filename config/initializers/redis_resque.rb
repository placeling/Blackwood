require 'resque/failure/multiple'
#require 'resque/failure/airbrake'
require 'resque/failure/redis'


redis_base = Redis.new  #assumes localhost n' stuff

Resque.redis = redis_base
Resque.redis.namespace = "resque:placeling"

#Resque::Failure::Airbrake.configure do |config|
#  config.api_key = '6cdd0c13c32d9b5cbd3ab510033319af'
#end

Resque::Failure::Multiple.classes = [Resque::Failure::Redis] #, Resque::Failure::Airbrake]
Resque::Failure.backend = Resque::Failure::Multiple

unless defined?(RESQUE_LOGGER)
  f = File.open("#{Rails.root}/log/resque.log", 'a+')
  f.sync = true
  RESQUE_LOGGER = ActiveSupport::BufferedLogger.new f
end

$redis = Redis::Namespace.new('blackwood', :redis => redis_base)
$redis.flushdb if Rails.env.test?


Resque::Server.use Rack::Auth::Basic do |username, password|
  password == "queueitup"
end
