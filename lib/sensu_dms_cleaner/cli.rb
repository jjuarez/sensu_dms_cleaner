# encoding:UTF-8
require 'thor'
require 'sensu_dms_cleaner/config'

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
    option :host,
      required: true,
      type:     :string,
      aliases:  '-h',
      desc:     'The host'
    def show
      Config.configure(options[:config])
      puts Config.to_h.inspect
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
      puts Config.to_h.inspect
    end
  end
end
