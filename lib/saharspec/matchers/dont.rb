module Saharspec
  module Matchers
    # @private
    class Not < RSpec::Matchers::BuiltIn::BaseMatcher
      def initialize
        @delegator = Delegator.new
      end

      def description
        "not #{@matcher.description}"
      end

      def match(_expected, actual)
        @matcher or fail(ArgumentError, 'dont matcher used without any negated matcher')
        !@matcher.matches?(actual)
      end

      def supports_block_expectations?
        @matcher.supports_block_expectations?
      end

      def method_missing(m, *a, &b)
        if @matcher
          @matcher.send(m, *a, &b)
        else
          @matcher = @delegator.send(m, *a, &b)
        end

        self
      end

      class Delegator
        include RSpec::Matchers
      end
    end
  end
end

module RSpec
  module Matchers
    # Negates attached matcher
    #
    # @example
    #   # before
    #   RSpec.define_negated_matcher :not_change, :change
    #   it { expect { code }.to do_stuff.and not_change(obj, :attr) }
    #
    #   # after: no `define_negated_matcher` needed
    #   it { expect { code }.to do_stuff.and dont.change(obj, :attr) }
    #
    def dont
      Saharspec::Matchers::Not.new
    end
  end
end
