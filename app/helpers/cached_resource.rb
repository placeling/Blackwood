require 'active_support/concern'

module CachedResource
  extend ActiveSupport::Concern

  included do
    class << self
      alias_method_chain :find, :cache
    end

    class_attribute :cache_for
  end

  module ClassMethods

    def cache_expires_in
      60*60*24 #expires after a day, by default
    end

    def find_with_cache(*arguments)
      begin
        key = cache_key(arguments)
        perma_key = perma_cache_key(arguments)

        find_with_read_through_cache(key, perma_key, *arguments)
      rescue ActiveResource::ServerError, ActiveResource::ConnectionError, Errno::ECONNREFUSED, SocketError => e
        Rails.cache.read(perma_key).try(:dup) || raise(e)
      end
    end

    private

    def find_with_read_through_cache(key, perma_key, *arguments)
      result = Rails.cache.read(key).try(:dup)

      unless result
        result = find_without_cache(*arguments)
        Rails.cache.write(key, result, :expires_in => self.cache_expires_in)
        Rails.cache.write(perma_key, result)
      end

      result
    end

    def cache_key(*arguments)
      "#{name}/#{arguments.join('/')}".downcase
    end

    def perma_cache_key(*arguments)
      "perma/#{name}-#{arguments.join('/')}".downcase
    end
  end

end
