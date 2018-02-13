# frozen_string_literal: true

module Adaptor
  # This error is raised when no adaptors can be found for an object and the adaptor is loaded
  # through {Loader::ClassMethods#load_adaptor!} or {Loader::ClassMethods#load_adaptors!}.
  class NoAdaptorError < StandardError
  end
end
