
redis_base = Redis.new()  #assumes localhost n' stuff

$redis = Redis::Namespace.new('blackwood', :redis => redis_base)
$redis.flushdb if Rails.env.test?

Resque.redis = redis_base
Resque.redis.namespace = "resque:blackwood"

unless defined?(RESQUE_LOGGER)
  f = File.open("#{Rails.root}/log/resque.log", 'a+')
  f.sync = true
  RESQUE_LOGGER = ActiveSupport::BufferedLogger.new f
end

Resque::Server.use Rack::Auth::Basic do |username, password|
  password == "queueitup"
end