# encoding:UTF-8
require 'thor'
require 'redis'
require 'sensu_dms_cleaner/version'

module SensuDmsCleaner
  #
  # = Class: ::SensuDmsCleaner::CLI - The CLI application
  class CLI < Thor
    DEFAULT_TIMEOUT  = 10
    DEFAULT_DB       = 0
    INCREMENTAL_TYPE = 'incremental'.freeze
    FULL_TYPE        = 'full'.freeze

    no_tasks do

      def build_redis_key(prefix, backup_host, backup_cluster, backup_type)
        incr_backup_pattern = "#{prefix}:#{backup_host}:backup.#{backup_cluster}.#{backup_type}"
      end

      def redis_pretty_print(connection, key)
        redis_type = connection.type(key).to_sym

        case redis_type
        when :list
          print "\t#{key}: #{connection.mget(key).map { |i| print i.inspect }}\n"
        else
          puts "\t#{key}: #{connection.get(key)}"
        end
      end
    end

    long_desc <<-LONGDESC
      This command show a serie of cluster backup events
    LONGDESC
		desc 'show CLUSTER', 'Shows all the sensu events related with a backup of CLUSTER'
	  option :redis, required: true, type: :string, aliases: '-r', desc: 'The redis URL'
    option :host,  required: true, type: :string, aliases: '-h', desc: 'The backup host'
    def show(cluster)
			redis_connection = ::Redis.new(url: options[:redis], db: DEFAULT_DB, timeout: DEFAULT_TIMEOUT)

      incr_backup_pattern = build_redis_key('*', options[:host], cluster, INCREMENTAL_TYPE)
      full_backup_pattern = build_redis_key('*', options[:host], cluster, FULL_TYPE)

      puts "Incremental backups:"
      redis_connection.keys(incr_backup_pattern).each { |k| redis_pretty_print(redis_connection, k) }

      puts "Full backups:"
      redis_connection.keys(full_backup_pattern).each { |k| redis_pretty_print(redis_connection, k) }
    rescue => rex
      $stderr.puts("Redis connection error: #{rex.message}")
      exit 1
    end


    long_desc <<-LONGDESC
      This command cleanup all the redis data related with a check: results, history, etc
    LONGDESC
    desc 'clear CLUSTER', 'Deletes all the sensu events related with a backup CLUSTER'
    option :redis, required: true, type: :string, aliases: '-r', desc: 'The redis URL'
    option :host,  required: true, type: :string, aliases: '-h', desc: 'The backup host'
    def clear(cluster)
      redis_connection = ::Redis.new(url: options[:redis], db: DEFAULT_DB, timeout: DEFAULT_TIMEOUT)

      result_key  = build_redis_key('result', options[:host], cluster, INCREMENTAL_TYPE)
      history_key = build_redis_key('history', options[:host], cluster, INCREMENTAL_TYPE)

      redis_connection.srem("result:#{options[:host]}", "backup.#{cluster}.#{INCREMENTAL_TYPE}")

      redis_connection.multi do
        redis_connection.del(history_key)
        redis_connection.del(result_key)
      end

      result_key  = build_redis_key('result', options[:host], cluster, FULL_TYPE)
      history_key = build_redis_key('history', options[:host], cluster, FULL_TYPE)

      redis_connection.srem("result:#{options[:host]}", "backup.#{cluster}.#{FULL_TYPE}")

      redis_connection.multi do
        redis_connection.del(history_key)
        redis_connection.del(result_key)
      end
    rescue => rex
      $stderr.puts("Redis connection error: #{rex.message}")
      exit 1
    end
    
    desc 'version', 'Shows the version of the application'
    def version
      puts "#{File.basename($0)} version: #{::SensuDmsCleaner::VERSION}" 
    end
  end
end
