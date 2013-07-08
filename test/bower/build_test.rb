require 'test_helper'

require 'bower/build'

module Bower
  class BuildTest < Minitest::Spec
    it 'should raise BuildError if no package is specified' do
      proc { Convert.new("") }.must_raise(BuildError)
    end
  end
end
