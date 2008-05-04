module PluginAWeek #:nodoc:
  module BooleanAttributes
    module ActiveRecord
      private
        # For Strings, returns true when value is:
        # * "true"
        # * "t"
        # 
        # For Integers, returns true when value is:
        # * 1
        def attr_predicate(symbol) 
          class_eval <<-end_eval
            def #{symbol}?
              ::ActiveRecord::ConnectionAdapters::Column.value_to_boolean(@#{symbol})
            end
          end_eval
        end
    end
  end
end

ActiveRecord::Base.class_eval do
  extend PluginAWeek::BooleanAttributes::ActiveRecord
end if defined?(ActiveRecord)
