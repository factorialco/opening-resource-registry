# typed: strict

module ResourceRegistry
  class Versions
    class Version
      extend T::Sig

      sig { params(name: String, aliases: T.nilable(T.any(String, T::Array[String]))).void }
      def initialize(name, aliases: nil)
        @name = name
        @aliases = T.let(Array(aliases), T::Array[String])
      end

      sig { returns(String) }
      attr_reader :name

      sig { returns(T::Array[String]) }
      attr_reader :aliases

      sig { returns(String) }
      def to_s
        name
      end

      sig { params(str: String).returns(T::Boolean) }
      def matches?(str)
        [name, *aliases].include?(str)
      end
    end
  end
end
