module PluginAWeek #:nodoc:
  module CoreExtensions #:nodoc:
    module Module #:nodoc:
      module BooleanAttributes
        # Defines a boolean attribute for this module, where the name is
        # symbol.id2name, creating an instance variable (@name), a corresponding
        # access method to read it, and a predicate method to test true/false.
        # If the optional writable argument is true, also creates a method
        # called name= to set the attribute.
        # 
        #   module Mod
        #     battr :is_okay, true
        #   end
        #   
        #   is equivalent to:
        #   
        #   module Mod
        #     def is_okay
        #       @is_okay
        #     end
        #     
        #     def is_okay=(val)
        #       @is_okay = val
        #     end
        #     
        #     def is_okay?
        #     end
        #   end
        def battr(symbol, writable = false)
          attr(symbol, writable)
          battr_predicate(symbol)
        end
        
        # Creates instance variables and corresponding methods that return the
        # value of each instance variable. Equivalent to calling battr(name)
        # on each name in turn.
        def battr_reader(*symbols)
          symbols.each {|symbol| battr(symbol, false)}
        end
        
        # Equivalent to calling battr(symbol, true) on each symbol in turn.
        # 
        #   module Mod
        #     battr_accessor(:is_good, :is_bad)
        #   end
        #   
        #   Mod.instance_methods.sort   #=> ["is_bad", "is_bad=", "is_bad?", "is_good", "is_good=", "is_good?"]
        def battr_accessor(*symbols)
          symbols.each {|symbol| battr(symbol, true)}
        end
        
        # Creates an accessor method to allow assignment to the attribute
        # aSymbol.id2name.
        def battr_writer(*symbols)
          symbols.each do |symbol|
            class_eval <<-end_eval
              def #{symbol}=(val)
                @symbol = val
              end
            end_eval
            battr_predicate(symbol)
          end
        end
        
        private
        def battr_predicate(symbol) #:nodoc:
          class_eval <<-end_eval
            def #{symbol}?
              if value = instance_variable_get("@#{symbol}")
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