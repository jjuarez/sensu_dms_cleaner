# encoding:UTF-8
require 'thor'
require 'redis'
require 'micro_config'
require 'sensu_dms_cleaner/version'

module SensuDmsCleaner
  #
  # = Class: ::SensuDmsCleaner::CLI - The CLI application
  class CLI < Thor
    long_desc <<-LONGDESC
      This command long desc
    LONGDESC
		desc 'show', 'Shows all the keys related with a host'
	  option :config,
      required: true,
			type:    :string,
      aliases: '-C',
      desc:    'The config file'
    option :environment,
      required: false,
      type:     :symbol,
      aliases:  '-e',
      defaul:   :development,
      desc:    'The environment'
    option :host,
      required: true,
      type:     :string,
      aliases:  '-h',
      desc:     'The host'
    option :check,
      required: true,
      type:     :string,
      aliases:  '-c',
      desc:     'The check'
    def show
      Config.configure(options[:config], { environment: options[:environment] })[:urls].each do |url|
				redis = Redis.new(url: url)
        redis.get("*:#{options[:host]}:#{options[:check]}")
      end
    end

    long_desc <<-LONGDESC
      This is anoher long description for the command
    LONGDESC
    desc 'delete', 'Deletes all the stuff related with a check'
	  option :config,
      required: true,
			type:    :string,
      aliases: '-C',
      desc:    'The config file'
    option :environment,
      required: false,
      type:     :symbol,
      aliases:  '-e',
      defaul:   :development,
      desc:    'The environment'
    option :host,
      required: true,
      type:     :string,
      aliases:  '-h',
      desc:     'The host'
    option :check,
      required: true,
      type:     :string,
      aliases:  '-c',
      desc:     'The check'
    def delete
      Config.configure(options[:config])
    end
    
    desc 'version', 'Shows the version of the application'
    def version
      puts "#{$0} version: #{::SensuDmsCleaner::VERSION}" 
    end
  end
end
