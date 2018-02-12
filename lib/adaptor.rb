require "adaptor/version"
require "adaptor/loader"
require "adaptor/errors"

module Adaptor
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def supports?(_object)
      fail NotImplementedError
    end
  end
end
