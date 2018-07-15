# frozen_string_literal: true

RSpec.describe Adaptor::Loader do
  subject { AdaptorTest::Loader }

  describe '#load_adaptor' do
    it 'loads the appropriate adaptor' do
      expect([
        subject.load_adaptor(1, foo: :bar),
        subject.load_adaptor(2, foo: :bar)
      ]).to match([
        an_instance_of(AdaptorTest::AdaptorOne),
        an_instance_of(AdaptorTest::AdaptorTwo)
      ])
    end

    it 'returns nil when no adaptor is found' do
      expect(subject.load_adaptor(3, foo: :bar)).to eq(nil)
    end
  end

  describe '#load_adaptors' do
    it 'loads the appropriate adaptor' do
      expect(subject.load_adaptors(2, foo: :bar)).to match([
        an_instance_of(AdaptorTest::AdaptorTwo),
        an_instance_of(AdaptorTest::AdaptorMultipleOfTwo)
      ])
    end

    it 'returns an empty array when no adaptors are found' do
      expect(subject.load_adaptors(3, foo: :bar)).to eq([])
    end
  end

  describe '#load_adaptors!' do
    it 'loads the appropriate adaptors' do
      expect(subject.load_adaptors!(2, foo: :bar)).to match([
        an_instance_of(AdaptorTest::AdaptorTwo),
        an_instance_of(AdaptorTest::AdaptorMultipleOfTwo)
      ])
    end

    it 'raises NoAdaptorError when no adaptors are found' do
      expect { subject.load_adaptors!(3, foo: :bar) }.to raise_error(Adaptor::NoAdaptorError)
    end
  end
end
