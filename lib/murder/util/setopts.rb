module MURDER
  module Util
    module Setopts

      private

      def setopts(opts, allowed)
        opts.each_pair do |key, value|
          if allowed.key?(key)
            rhs = allowed[key]
            case rhs
            when NilClass, FalseClass
              # Ignore nil options
            when :self, TrueClass
              instance_variable_set("@#{key}".to_sym, value)
            else
              instance_variable_set("@#{rhs}".to_sym, value)
            end
          else
            raise ArgumentError, "#{self.class.name} cannot handle option '#{key}'"
          end
        end
      end
    end
  end
end
