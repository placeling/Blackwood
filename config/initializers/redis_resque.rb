
redis_base = Redis.new()  #assumes localhost n' stuff

$redis = Redis::Namespace.new('blackwood', :redis => redis_base)
$redis.flushdb if Rails.env.test?
