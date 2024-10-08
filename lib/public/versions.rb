# typed: strict

require 'active_support'
require 'active_support/core_ext'

module ResourceRegistry
  class Versions
    extend T::Sig
    extend T::Helpers

    sig { params(versions: T::Array[Version]).void }
    def initialize(versions:)
      @versions = versions
    end

    sig { params(name: T.nilable(String)).returns(T.nilable(Version)) }
    def find(name)
      return if name.blank?

      versions.find { |version| version.matches?(name) }
    end

    sig { params(name: String).returns(Version) }
    def find!(name)
      find(name) || raise("Version '#{name}' not found")
    end

    private

    sig { returns(T::Array[Version]) }
    attr_reader :versions
  end
end
