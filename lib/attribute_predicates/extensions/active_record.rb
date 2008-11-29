module PluginAWeek #:nodoc:
  module AttributePredicates
    module Extensions
      # Adds support for automatically defining predicate methods using +attr_predicate+
      # when defining attributes using +attr+, +attr_reader+, +attr_reader+, and
      # +attr_accessor+.  In comparison to normal Ruby attributes, ActiveRecord
      # predicates use a different system for defining true/false.
      # 
      # == Examples
      # 
      # The predicate methods for attributes use ActiveRecord's type conversion
      # for booleans for determing whether to return true or false.  For example,
      # 
      #   class Person < ActiveRecord::Base
      #     attr_accessor :value
      #   end
      #   
      #   p = Person.new
      #   p.value = false
      #   p.value?    # => false
      #   
      #   p.value = 'false'
      #   p.value?    # => false
      #   
      #   p.value = 'true'
      #   p.value?    # => true
      #   
      #   p.value = 't'
      #   p.value?    # => true
      #   
      #   p.value = 1
      #   p.value?    # => true
      module ActiveRecord
        private
          # For Strings, returns true when value is:
          # * "true"
          # * "t"
          # 
          # For Integers, returns true when value is:
          # * 1
          def attr_predicate(symbol)
            define_method("#{symbol}?") do
              ::ActiveRecord::ConnectionAdapters::Column.value_to_boolean(instance_variable_get("@#{symbol}")) == true
            end
          end
      end
    end
  end
end

ActiveRecord::Base.class_eval do
  extend PluginAWeek::AttributePredicates::Extensions::ActiveRecord
end if defined?(ActiveRecord)
