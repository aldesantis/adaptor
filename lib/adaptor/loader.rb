# frozen_string_literal: true

module Adaptor
  # An adaptor loader holds and loads the adapter(s) which support an object.
  #
  # @example Defining a loader
  #   module NotificationProcessor
  #     include Adaptor::Loader
  #     register Email, Sms
  #   end
  module Loader
    def self.included(klass)
      klass.extend ClassMethods
    end

    module ClassMethods
      # Registers one or more new adaptors with the loader.
      #
      # @param [Array<Class>] klasses the adaptors to register
      def register(*klasses)
        klasses.each do |klass|
          adaptors << klass unless adaptors.include?(klass)
        end
      end

      # Returns the adaptors registered with this loader.
      #
      # @return [Array<Class>]
      def adaptors
        @adaptors ||= []
      end

      # Loads the first available adaptor for the given object.
      #
      # @param [Object] object the object to load the adaptor for
      #
      # @return [Object|NilClass] an instance of the adpator or nil if no adaptor was found
      def load_adaptor(object)
        adaptors.find { |adaptor_klass| adaptor_klass.supports?(object) }&.new(object)
      end

      # Loads the first available adaptor for the given object.
      #
      # @param [Object] object the object to load the adaptor for
      #
      # @return [Object] an instance of the adaptor
      #
      # @raise [NoAdaptorError] when no adaptor was found
      def load_adaptor!(object)
        load_adaptor(object) || fail(NoAdaptorError, "No adaptor found for #{object}")
      end

      # Loads all the adaptors which support the given object.
      #
      # @param [Object] object the object to load the adaptors for
      #
      # @return [Array] instances of compatible adaptors
      def load_adaptors(object)
        adaptors.map do |adaptor_klass|
          next unless adaptor_klass.supports?(object)
          adaptor_klass.new(object)
        end.compact
      end

      # Loads all the adaptors which support the given object.
      #
      # @param [Object] object the object to load the adaptors for
      #
      # @return [Array] instances of compatible adaptors
      #
      # @raise [NoAdaptorError] when no adaptors are found
      def load_adaptors!(object)
        adaptors = load_adaptors(object)
        adaptors.any? ? adaptors : fail(NoAdaptorError, "No adaptors found for #{object}")
      end
    end
  end
end
