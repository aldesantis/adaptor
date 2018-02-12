# frozen_string_literal: true

module Adaptor
  module Loader
    def self.included(klass)
      klass.extend ClassMethods
    end

    module ClassMethods
      def register(*klasses)
        klasses.each do |klass|
          adaptors << klass unless adaptors.include?(klass)
        end
      end

      def adaptors
        @adaptors ||= []
      end

      def load_adaptor(object)
        adaptors.find { |adaptor_klass| adaptor_klass.supports?(object) }&.new(object)
      end

      def load_adaptor!(object)
        load_adaptor(object) || fail(NoAdaptorError, "No adaptor found for #{object}")
      end

      def load_adaptors(object)
        adaptors.map do |adaptor_klass|
          next unless adaptor_klass.supports?(object)
          adaptor_klass.new(object)
        end.compact
      end

      def load_adaptors!(object)
        adaptors = load_adaptors(object)
        adaptors.any? ? adaptors : fail(NoAdaptorError, "No adaptors found for #{object}")
      end
    end
  end
end
