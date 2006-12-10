require File.dirname(__FILE__) + '/test_helper'

class Module
  public :battr_predicate
end

class BooleanAttributesTest < Test::Unit::TestCase
  def setup
    @klass = Class.new do
      def initialize(value)
        self.foo = value
      end
    end
  end
  
  def test_battr_not_writable
    @klass.battr(:foo)
    ['foo', 'foo?'].each do |method|
      assert @klass.instance_methods.include?(method), "#{method} does not exist"
    end
    
    ['foo='].each do |method|
      assert !@klass.instance_methods.include?(method), "#{method} exists"
    end
  end
  
  def test_battr_writable
    @klass.battr(:foo, true)
    ['foo', 'foo=', 'foo?'].each do |method|
      assert @klass.instance_methods.include?(method), "#{method} does not exist"
    end
  end
  
  def test_battr_reader
    @klass.battr_reader(:foo)
    ['foo', 'foo?'].each do |method|
      assert @klass.instance_methods.include?(method), "#{method} does not exist"
    end
    
    ['foo='].each do |method|
      assert !@klass.instance_methods.include?(method), "#{method} exists"
    end
  end
  
  def test_battr_reader_with_multiple_attributes
    @klass.battr_reader(:foo, :bar)
    ['foo', 'foo?', 'bar', 'bar?'].each do |method|
      assert @klass.instance_methods.include?(method), "#{method} does not exist"
    end
    
    ['foo=', 'bar='].each do |method|
      assert !@klass.instance_methods.include?(method), "#{method} exists"
    end
  end
  
  def test_battr_accessor
    @klass.battr_accessor(:foo)
    ['foo', 'foo=', 'foo?'].each do |method|
      assert @klass.instance_methods.include?(method), "#{method} does not exist"
    end
  end
  
  def test_battr_accessor_with_multiple_attributes
    @klass.battr_accessor(:foo, :bar)
    ['foo', 'foo=', 'foo?', 'bar', 'bar=', 'bar?'].each do |method|
      assert @klass.instance_methods.include?(method), "#{method} does not exist"
    end
  end
  
  def test_battr_writer
    @klass.battr_writer(:foo)
    ['foo=', 'foo?'].each do |method|
      assert @klass.instance_methods.include?(method), "#{method} does not exist"
    end
    
    ['foo'].each do |method|
      assert !@klass.instance_methods.include?(method), "#{method} exists"
    end
  end
  
  def test_battr_writer_with_multiple_attributes
    @klass.battr_writer(:foo, :bar)
    ['foo=', 'foo?', 'bar=', 'bar?'].each do |method|
      assert @klass.instance_methods.include?(method), "#{method} does not exist"
    end
    
    ['foo', 'bar'].each do |method|
      assert !@klass.instance_methods.include?(method), "#{method} exists"
    end
  end
  
  def test_battr_predicate
    @klass.battr_predicate(:foo)
    assert @klass.instance_methods.include?('foo?'), "foo? does not exist"
  end
  
  def test_battr_predicate_string
    @klass.battr_accessor(:foo)
    
    [nil, ''].each do |value|
      assert_equal false, @klass.new(value).foo?, "#{value.inspect} is true"
    end
    
    assert_equal true, @klass.new('Name').foo?, '"Name" is false'
  end
  
  def test_battr_predicate_number
    @klass.battr_accessor(:foo)
    
    [nil, 0, '0'].each do |value|
      assert_equal false, @klass.new(value).foo?, "#{value.inspect} is true"
    end
    
    assert_equal true, @klass.new(1).foo?, '1 is false'
    assert_equal true, @klass.new('1').foo?, '"1" is false'
  end
  
  def test_battr_predicate_boolean
    @klass.battr_accessor(:foo)
    
    [nil, '', false, 'false', 'f', 0].each do |value|
      assert_equal false, @klass.new(value).foo?, "#{value.inspect} is true"
    end
    
    [true, 'true', '1', 1].each do |value|
      assert_equal true, @klass.new(value).foo?, "#{value.inspect} is false"
    end
  end
end
