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
end