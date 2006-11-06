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
        # 
        def battr(symbol, writable = false)
          attr(symbol, writable)
          battr_predicate(symbol)
        end
        
        # Creates instance variables and corresponding methods that return the
        # value of each instance variable. Equivalent to calling battr(name)
        # on each name in turn.
        # 
        def battr_reader(*symbols)
          symbols.each do |symbol|
            battr(symbol, false)
          end
        end
        
        # Equivalent to calling battr(symbol, true) on each symbol in turn.
        # 
        #   module Mod
        #     battr_accessor(:is_good, :is_bad)
        #   end
        #   
        #   Mod.instance_methods.sort   #=> ["is_bad", "is_bad=", "is_bad?", "is_good", "is_good=", "is_good?"]
        # 
        def battr_accessor(*symbols)
          symbols.each do |symbol|
            battr(symbol, true)
          end
        end
        
        # Creates an accessor method to allow assignment to the attribute
        # aSymbol.id2name.
        #
        def battr_writer(*symbols)
          symbols.each do |symbol|
            class_eval(<<-EOS, __FILE__, __LINE__)
              def #{symbol}=(val)
                @symbol = val
              end
              battr_predicate(symbol)
            EOS
          end
        end
        
        private
        def battr_predicate(symbol) #:nodoc:
          class_eval(<<-EOS, __FILE__, __LINE__)
            def #{symbol}?
              attribute = instance_variable_get("@#{symbol}")
              if attribute.kind_of?(Fixnum) && attribute == 0
                false
              elsif attribute.kind_of?(String) && attribute == '0'
                false
              elsif attribute.kind_of?(String) && attribute.empty?
                false
              elsif attribute.nil?
                false
              elsif attribute == false
                false
              elsif attribute == 'f'
                false
              elsif attribute == 'false'
                false
              else
                true
              end
            end
          EOS
        end
      end
    end
  end
end

class ::Module
  include PluginAWeek::CoreExtensions::Module::BooleanAttributes
end