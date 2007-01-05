require File.dirname(__FILE__) + '/test_helper'

class Module
  public  :attr,
          :attr_reader,
          :attr_writer,
          :attr_accessor,
          :attr_predicate
end

class BooleanAttributesTest < Test::Unit::TestCase
  def setup
    @klass = Class.new do
      def initialize(value)
        self.foo = value
      end
    end
  end
  
  def test_attr_not_writable
    @klass.attr(:foo)
    ['foo', 'foo?'].each do |method|
      assert @klass.instance_methods.include?(method), "#{method} does not exist"
    end
    
    ['foo='].each do |method|
      assert !@klass.instance_methods.include?(method), "#{method} exists"
    end
  end
  
  def test_attr_writable
    @klass.attr(:foo, true)
    ['foo', 'foo=', 'foo?'].each do |method|
      assert @klass.instance_methods.include?(method), "#{method} does not exist"
    end
  end
  
  def test_attr_reader
    @klass.attr_reader(:foo)
    ['foo', 'foo?'].each do |method|
      assert @klass.instance_methods.include?(method), "#{method} does not exist"
    end
    
    ['foo='].each do |method|
      assert !@klass.instance_methods.include?(method), "#{method} exists"
    end
  end
  
  def test_attr_reader_with_multiple_attributes
    @klass.attr_reader(:foo, :bar)
    ['foo', 'foo?', 'bar', 'bar?'].each do |method|
      assert @klass.instance_methods.include?(method), "#{method} does not exist"
    end
    
    ['foo=', 'bar='].each do |method|
      assert !@klass.instance_methods.include?(method), "#{method} exists"
    end
  end
  
  def test_attr_accessor
    @klass.attr_accessor(:foo)
    ['foo', 'foo=', 'foo?'].each do |method|
      assert @klass.instance_methods.include?(method), "#{method} does not exist"
    end
  end
  
  def test_attr_accessor_with_multiple_attributes
    @klass.attr_accessor(:foo, :bar)
    ['foo', 'foo=', 'foo?', 'bar', 'bar=', 'bar?'].each do |method|
      assert @klass.instance_methods.include?(method), "#{method} does not exist"
    end
  end
  
  def test_attr_writer
    @klass.attr_writer(:foo)
    ['foo=', 'foo?'].each do |method|
      assert @klass.instance_methods.include?(method), "#{method} does not exist"
    end
    
    ['foo'].each do |method|
      assert !@klass.instance_methods.include?(method), "#{method} exists"
    end
  end
  
  def test_attr_writer_with_multiple_attributes
    @klass.attr_writer(:foo, :bar)
    ['foo=', 'foo?', 'bar=', 'bar?'].each do |method|
      assert @klass.instance_methods.include?(method), "#{method} does not exist"
    end
    
    ['foo', 'bar'].each do |method|
      assert !@klass.instance_methods.include?(method), "#{method} exists"
    end
  end
  
  def test_attr_predicate
    @klass.attr_predicate(:foo)
    assert @klass.instance_methods.include?('foo?'), 'foo? does not exist'
  end
  
  def test_attr_predicate_false
    @klass.attr_accessor(:foo)
    
    [nil, '', ' ', {}, []].each do |value|
      assert_equal false, @klass.new(value).foo?, "#{value.inspect} is true"
    end
  end
  
  def test_attr_predicate_true
    @klass.attr_accessor(:foo)
    
    [1, 'hello world', {1 => 1}, [1]].each do |value|
      assert_equal true, @klass.new(value).foo?, "#{value.inspect} is false"
    end
  end
end

class ActiveRecordBooleanAttributesTest < Test::Unit::TestCase
  def setup
    @klass = Class.new(ActiveRecord::Base) do
      def initialize(value)
        self.foo = value
      end
    end
  end
  
  def test_attr_predicate_string
    @klass.attr_accessor(:foo)
    
    [nil, ''].each do |value|
      assert_equal false, @klass.new(value).foo?, "#{value.inspect} is true"
    end
    
    assert_equal true, @klass.new('Name').foo?, '"Name" is false'
  end
  
  def test_attr_predicate_number
    @klass.attr_accessor(:foo)
    
    [nil, 0, '0'].each do |value|
      assert_equal false, @klass.new(value).foo?, "#{value.inspect} is true"
    end
    
    assert_equal true, @klass.new(1).foo?, '1 is false'
    assert_equal true, @klass.new('1').foo?, '"1" is false'
  end
  
  def test_attr_predicate_boolean
    @klass.attr_accessor(:foo)
    
    [nil, '', false, 'false', 'f', 0].each do |value|
      assert_equal false, @klass.new(value).foo?, "#{value.inspect} is true"
    end
    
    [true, 'true', '1', 1].each do |value|
      assert_equal true, @klass.new(value).foo?, "#{value.inspect} is false"
    end
  end
end
