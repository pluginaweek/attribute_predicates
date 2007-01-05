module PluginAWeek #:nodoc:
  module CoreExtensions #:nodoc:
    module Module #:nodoc:
      # Adds predicate methods automatically to all calls to attr, attr_reader,
      # attr_writer, and attr_accessor
      module BooleanAttributes
        def self.included(base)
          base.class_eval do
            [:attr, :attr_reader, :attr_writer, :attr_accessor].each do |method|
              alias_method_chain method, :predicates
            end
          end
        end
        
        def attr_with_predicates(*args) #:nodoc:
          attr_without_predicates(*args)
          attr_predicate(args.first)
        end
        
        [:attr_reader, :attr_writer, :attr_accessor].each do |method|
          eval <<-end_eval
            def #{method}_with_predicates(*symbols)
              #{method}_without_predicates(*symbols)
              symbols.each {|symbol| attr_predicate(symbol)}
            end
          end_eval
        end
        
        private
        # Returns true if the specified variable is not blank, otherwise false
        def attr_predicate(symbol)
          class_eval <<-end_eval
            def #{symbol}?
              !#{symbol}.blank?
            end
          end_eval
        end
      end
    end
    
    module ActiveRecord #:nodoc:
      module BooleanAttributes
        private
        # For Strings, returns false when value is:
        # * "false"
        # * "f"
        # * "0"
        # * nil
        # 
        # For Integers, returns false when value is:
        # * 0
        # * nil
        def attr_predicate(symbol) 
          class_eval <<-end_eval
            def #{symbol}?
              if value = #{symbol}
                if value.kind_of?(String)
                  !value.empty? && !%w(false f 0).include?(value)
                elsif value.kind_of?(Numeric)
                  !value.zero?
                else
                  true
                end
              else
                false
              end
            end
          end_eval
        end
      end
    end
  end
end

class ::Module
  include PluginAWeek::CoreExtensions::Module::BooleanAttributes
end

ActiveRecord::Base.class_eval do
  extend PluginAWeek::CoreExtensions::ActiveRecord::BooleanAttributes
end