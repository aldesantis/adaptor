module AdaptorTest
  class AdaptorOne
    include Adaptor

    def self.supports?(val)
      val == 1
    end

    def initialize(_val, _options)
    end
  end

  class AdaptorTwo
    include Adaptor

    def self.supports?(val)
      val == 2
    end

    def initialize(_val, _options)
    end
  end

  class AdaptorMultipleOfTwo
    include Adaptor

    def self.supports?(val)
      (val % 2).zero?
    end

    def initialize(_val, _options)
    end
  end

  module Loader
    include Adaptor::Loader
    register AdaptorOne, AdaptorTwo, AdaptorMultipleOfTwo
  end
end
