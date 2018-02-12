# frozen_string_literal: true

RSpec.describe Adaptor do
  subject { AdaptorTest::AdaptorOne }

  it 'defines .supports?' do
    expect(subject).to respond_to(:supports?)
  end
end
