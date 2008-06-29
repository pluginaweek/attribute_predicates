require File.dirname(__FILE__) + '/test_helper'

class ActiveRecordTest < Test::Unit::TestCase
  def setup
    @klass = Class.new(ActiveRecord::Base) do
      def initialize(value)
        self.foo = value
      end
    end
  end
  
  def test_should_evaluate_string_values
    @klass.attr_accessor(:foo)
    
    [nil, '', 'Name'].each do |value|
      assert_equal false, @klass.new(value).foo?, "#{value.inspect} is true"
    end
  end
  
  def test_should_evaluate_numeric_values
    @klass.attr_accessor(:foo)
    
    [nil, 0, '0'].each do |value|
      assert_equal false, @klass.new(value).foo?, "#{value.inspect} is true"
    end
    
    assert_equal true, @klass.new(1).foo?, '1 is false'
    assert_equal true, @klass.new('1').foo?, '"1" is false'
  end
  
  def test_should_evaluate_boolean_values
    @klass.attr_accessor(:foo)
    
    [nil, '', false, 'false', 'f', 0].each do |value|
      assert_equal false, @klass.new(value).foo?, "#{value.inspect} is true"
    end
    
    [true, 'true', '1', 1].each do |value|
      assert_equal true, @klass.new(value).foo?, "#{value.inspect} is false"
    end
  end
end
