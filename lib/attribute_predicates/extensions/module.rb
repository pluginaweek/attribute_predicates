module PluginAWeek #:nodoc:
  module AttributePredicates
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

::Module.class_eval do
  include PluginAWeek::AttributePredicates::Module
end
