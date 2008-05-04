module PluginAWeek #:nodoc:
  module BooleanAttributes
    module Module
      def self.included(base) #:nodoc:
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
              !@#{symbol}.blank?
            end
          end_eval
        end
    end
  end
end

::Module.class_eval do
  include PluginAWeek::BooleanAttributes::Module
end
