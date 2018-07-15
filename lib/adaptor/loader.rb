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
      # @param [Array] args any arguments to pass to the adaptor's +.supports?+ and +.new+
      #
      # @return [Object|NilClass] an instance of the adpator or nil if no adaptor was found
      def load_adaptor(*args)
        adaptor_klass = adaptors.find do |klass|
          adaptor_supports?(klass, args)
        end

        instantiate_adaptor(adaptor_klass, args) if adaptor_klass
      end

      # Loads the first available adaptor for the given object.
      #
      # @param [Array] args any arguments to pass to the adaptor's +.supports?+ and +.new+
      #
      # @return [Object] an instance of the adaptor
      #
      # @raise [NoAdaptorError] when no adaptor was found
      def load_adaptor!(*args)
        load_adaptor(*args) || fail(NoAdaptorError, "No adaptor found for #{args.inspect}")
      end

      # Loads all the adaptors which support the given object.
      #
      # @param [Array] args any arguments to pass to the adaptors' +.supports?+ and +.new+
      #
      # @return [Array] instances of compatible adaptors
      def load_adaptors(*args)
        adaptors.map do |adaptor_klass|
          next unless adaptor_supports?(adaptor_klass, args)
          instantiate_adaptor(adaptor_klass, args)
        end.compact
      end

      # Loads all the adaptors which support the given object.
      #
      # @param [Array] args any arguments to pass to the adaptors' +.supports?+ and +.new+
      #
      # @return [Array] instances of compatible adaptors
      #
      # @raise [NoAdaptorError] when no adaptors are found
      def load_adaptors!(*args)
        adaptors = load_adaptors(*args)
        adaptors.any? ? adaptors : fail(NoAdaptorError, "No adaptors found for #{args.inspect}")
      end

      private

      def adaptor_supports?(adaptor, args)
        adaptor.supports?(*cut_args(args, method: adaptor.method(:supports?)))
      end

      def instantiate_adaptor(adaptor, args)
        adaptor.new(*cut_args(args, method: adaptor.method(:new)))
      end

      def cut_args(args, method:)
        arity = method.arity
        arity.negative? ? args : args[0..(arity - 1)]
      end
    end
  end
end
