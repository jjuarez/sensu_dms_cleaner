# encoding:UTF-8
require 'yaml'

module SensuDmsCleaner
  #
  # = Module: Config - support for a basic yaml configuration
  module Config
    extend self

    def to_h
      @config ||= {}
    end

    def [](key, default = nil)
      @config ||= {}
      @config.keys.include?(key) ? @config[key] : default
    end

    def fetch(key, default = nil)
      @config ||= {}
      @config.keys.include?(key) ? @config[key] : default
    end

    def configure(source = nil, options = {}, &block)
      @config ||= {}

      if options[:environment]
        case source
        when /\.(yml|yaml)/i then @config.merge!(YAML.load(IO.read(source))[options[:environment]])
        when Hash            then @config.merge!(source[options[:environment]])
        else
          yield self if block_given?
        end
      else
        case source
        when /\.(yml|yaml)/i then @config.merge!(YAML.load(IO.read(source)))
        when Hash            then @config.merge!(source)
        else
          yield self if block_given?
        end
      end

      self
    rescue
      raise("Problems loading config source: #{source}")
    end

    def configure!(source = nil, options = {}, &block)
      @config ||= {}

      if options[:environment]
        case source
        when /\.(yml|yaml)/i then @config = YAML.load(IO.read(source))[options[:environment]]
        when Hash            then @config = source[options[:environment]]
        else
          yield self if block_given?
        end
      else
        case source
        when /\.(yml|yaml)/i then @config = YAML.load(IO.read(source))
        when Hash            then @config = source
        else
          yield self if block_given?
        end
      end
    rescue
      raise("Problems loading config source: #{source}")
    end

    def method_missing(method, *arguments, &block)
      @config ||= {}

      case method.to_s
      when /(.+)=$/  then
        key          = method.to_s.delete('=')
        @config[key] = arguments.size == 1 ? arguments[0] : arguments
      when /(.+)\?$/ then
        key = method.to_s.delete('?')

        @config.keys.include?(key)
      else
        key = method.to_s

        if @config.keys.include?(key)
          @config[key]
        else
          super
        end
      end
    end
  end
end
