module PluginAWeek #:nodoc:
  module AttributePredicates
    module Extensions
      # Adds support for automatically defining predicate methods using +attr_predicate+
      # when defining attributes using +attr+, +attr_reader+, +attr_reader+, and
      # +attr_accessor+.
      # 
      # == Examples
      # 
      # The predicate methods for attributes checks whether the value is blank?
      # for determining whether true or false should be returned.  For example,
      # 
      #   class Person
      #     attr_accessor :value
      #   end
      #   
      #   p = Person.new
      #   p.value = false
      #   p.value?    # => false
      #   
      #   p.value = true
      #   p.value?    # => true
      #   
      #   p.value = []
      #   p.value?    # => false
      #   
      #   p.value = [false]
      #   p.value?    # => true
      module Module
        def self.included(base) #:nodoc:
          base.class_eval do
            [:attr, :attr_reader, :attr_writer, :attr_accessor].each do |method|
              alias_method_chain method, :predicates
            end
          end
        end
        
        # Defines a predicate method, using +attr_predicate+, in addition to the
        # attribute accessors.  For example,
        # 
        #   module Mod
        #     attr :is_okay
        #   end
        #   
        #   Mod.instance-methods.sort #=> ["is_okay", "is_okay?"]
        def attr_with_predicates(*args)
          attr_without_predicates(*args)
          attr_predicate(args.first)
        end
        
        [:attr_reader, :attr_writer, :attr_accessor].each do |method|
          define_method("#{method}_with_predicates") do |*symbols|
            send("#{method}_without_predicates", *symbols)
            symbols.each {|symbol| attr_predicate(symbol)}
          end
        end
        
        private
          # Returns true if the specified variable is not blank, otherwise false
          def attr_predicate(symbol)
            define_method("#{symbol}?") do
              !instance_variable_get("@#{symbol}").blank?
            end
          end
      end
    end
  end
end

::Module.class_eval do
  include PluginAWeek::AttributePredicates::Extensions::Module
end
