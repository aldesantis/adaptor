# frozen_string_literal: true

require 'adaptor/version'
require 'adaptor/loader'
require 'adaptor/errors'

# Adaptor makes it easy to implement the Adapter pattern in Ruby.
#
# @example Defining a new adaptor
#   class EmailAdaptor
#     include Adaptor
#
#     def self.supports?(notification)
#       notification.recipient.email.present?
#     end
#   end
module Adaptor
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    # Returns whether this adaptor supports the given object.
    #
    # @param [Object] _object the object to test
    #
    # @return [Boolean] whether the adaptor supports the object
    def supports?(_object)
      fail NotImplementedError
    end
  end
end
