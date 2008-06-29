require File.dirname(__FILE__) + '/test_helper'

class Module
  public  :attr,
          :attr_reader,
          :attr_writer,
          :attr_accessor,
          :attr_predicate
end

class ModuleAttrTest < Test::Unit::TestCase
  def setup
    @module = Module.new
  end
  
  def test_should_create_predicate_for_readonly_attr
    @module.attr(:foo)
    ['foo', 'foo?'].each do |method|
      assert @module.instance_methods.include?(method), "#{method} does not exist"
    end
    
    ['foo='].each do |method|
      assert !@module.instance_methods.include?(method), "#{method} exists"
    end
  end
  
  def test_should_create_predicate_for_readwrite_attr
    @module.attr(:foo, true)
    ['foo', 'foo=', 'foo?'].each do |method|
      assert @module.instance_methods.include?(method), "#{method} does not exist"
    end
  end
end

class ModuleAttrReaderTest < Test::Unit::TestCase
  def setup
    @module = Module.new
  end
  
  def test_should_create_predicate
    @module.attr_reader(:foo)
    ['foo', 'foo?'].each do |method|
      assert @module.instance_methods.include?(method), "#{method} does not exist"
    end
    
    ['foo='].each do |method|
      assert !@module.instance_methods.include?(method), "#{method} exists"
    end
  end
  
  def test_should_create_predicate_for_multiple_attributes
    @module.attr_reader(:foo, :bar)
    ['foo', 'foo?', 'bar', 'bar?'].each do |method|
      assert @module.instance_methods.include?(method), "#{method} does not exist"
    end
    
    ['foo=', 'bar='].each do |method|
      assert !@module.instance_methods.include?(method), "#{method} exists"
    end
  end
end

class ModuleAttrAccessorTest < Test::Unit::TestCase
  def setup
    @module = Module.new
  end
  
  def test_should_create_predicate
    @module.attr_accessor(:foo)
    ['foo', 'foo=', 'foo?'].each do |method|
      assert @module.instance_methods.include?(method), "#{method} does not exist"
    end
  end
  
  def test_should_create_predicate_for_multiple_attributes
    @module.attr_accessor(:foo, :bar)
    ['foo', 'foo=', 'foo?', 'bar', 'bar=', 'bar?'].each do |method|
      assert @module.instance_methods.include?(method), "#{method} does not exist"
    end
  end
end

class ModuleAttrWriterTest < Test::Unit::TestCase
  def setup
    @module = Module.new
  end
  
  def test_should_create_predicate
    @module.attr_writer(:foo)
    ['foo=', 'foo?'].each do |method|
      assert @module.instance_methods.include?(method), "#{method} does not exist"
    end
    
    ['foo'].each do |method|
      assert !@module.instance_methods.include?(method), "#{method} exists"
    end
  end
  
  def test_should_create_predicate_for_multiple_attributes
    @module.attr_writer(:foo, :bar)
    ['foo=', 'foo?', 'bar=', 'bar?'].each do |method|
      assert @module.instance_methods.include?(method), "#{method} does not exist"
    end
    
    ['foo', 'bar'].each do |method|
      assert !@module.instance_methods.include?(method), "#{method} exists"
    end
  end
end

class ModuleAttrPredicateTest < Test::Unit::TestCase
  def setup
    @module = Module.new
  end
  
  def test_should_create_predicate
    @module.attr_predicate(:foo)
    assert @module.instance_methods.include?('foo?'), 'foo? does not exist'
  end
end
  
class ModuleTest < Test::Unit::TestCase
  def setup
    @klass = Class.new do
      def initialize(value)
        self.foo = value
      end
    end
  end
  
  def test_should_evaluate_false_values_for_predicate
    @klass.attr_accessor(:foo)
    
    [nil, '', ' ', {}, []].each do |value|
      assert_equal false, @klass.new(value).foo?, "#{value.inspect} is true"
    end
  end
  
  def test_should_evaluate_true_values_for_predicate
    @klass.attr_accessor(:foo)
    
    [1, 'hello world', {1 => 1}, [1]].each do |value|
      assert_equal true, @klass.new(value).foo?, "#{value.inspect} is false"
    end
  end
end
