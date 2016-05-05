# encoding:UTF-8
require 'spec_helper'

RSpec.describe SensuDmsCleaner do
  context 'Version' do
    it 'has one' do
      expect(SensuDmsCleaner::VERSION).not_to be nil
    end

    it 'is a semantic version number' do
      expect(SensuDmsCleaner::VERSION.split('.').size).to eq(3)
      expect(SensuDmsCleaner::VERSION.split('.').all? { |n| n.to_i.is_a?(Fixnum) }).to eq(true)
    end
  end

  context 'Basic' do
    it 'by default it initializes to {}' do
      expect(SensuDmsCleaner::Config.to_h).to eq({})
    end

    it 'has a [] method' do
      expect(SensuDmsCleaner::Config[:foo]).to be_nil
      expect(SensuDmsCleaner::Config[:foo, 'default value']).to eq('default value')
    end

    it 'has a fetch method' do
      expect(SensuDmsCleaner::Config.respond_to?(:fetch)).to eq(true)
    end

    it 'has a fetch method with default value' do
      expect(SensuDmsCleaner::Config.fetch(:foo, 'value')).to eq('value')
    end
  end

  context 'Configure' do
    it 'from a hash source' do
      expect(SensuDmsCleaner::Config.configure({ foo: 'First Value' })[:foo]).to eq('First Value')
      expect(SensuDmsCleaner::Config.configure!(foo: 'Second Value')[:foo]).to eq('Second Value')
    end

    it 'from a yaml file that not exist' do
      expect{SensuDmsCleaner::Config.configure('spec/fixtures/a_config_file_that_not_exist.yaml')}.to raise_error(StandardError)
    end

    it 'from a yaml file' do
      expect(SensuDmsCleaner::Config.configure!('spec/fixtures/plain_config.yaml')['foo']).to eq('Foo')
      expect(SensuDmsCleaner::Config.configure!('foo' =>'Second Value')['foo']).to eq('Second Value')
    end

    it 'from a block' do
      SensuDmsCleaner::Config.configure do |config|
        config.block_key1 = 'block value1'
        config.block_key2 = 'block value2'
      end
      expect(SensuDmsCleaner::Config.block_key1).to eq('block value1')
      expect(SensuDmsCleaner::Config.block_key2).to eq('block value2')
      expect(SensuDmsCleaner::Config.to_h).to include('block_key1' =>'block value1')
      expect(SensuDmsCleaner::Config.to_h).to include('block_key2' =>'block value2')
    end
  end

  context 'Keys' do
    it 'can insert' do
      expect(SensuDmsCleaner::Config.key='value').to eq('value')
    end

    it 'can query' do
      expect(SensuDmsCleaner::Config.key?).to be true
      expect(SensuDmsCleaner::Config.key_that_not_exist?).to be false
    end

    it 'can retrieve' do
      expect(SensuDmsCleaner::Config.key).to eq('value')
    end
  end
end
