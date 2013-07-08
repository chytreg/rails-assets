require "rubygems"
require "bundler/setup"

require 'minitest/autorun'
require 'minitest/pride'

require 'fileutils'
require 'test_support/gem_factory'

module TestMethodMagic
  def test(test_name, &block)
    define_method "test_method: #{test_name} ", &block
  end
end

class Minitest::Test
  extend TestMethodMagic
end

