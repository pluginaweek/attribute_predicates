module PluginAWeek #:nodoc:
  module AttributePredicates
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
            ::ActiveRecord::ConnectionAdapters::Column.value_to_boolean(instance_variable_get("@#{symbol}"))
          end
        end
    end
  end
end

ActiveRecord::Base.class_eval do
  extend PluginAWeek::AttributePredicates::ActiveRecord
end if defined?(ActiveRecord)
