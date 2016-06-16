require 'spec_helper'

RSpec.describe WePay do

  describe ".configure" do
    before do
      WePay.configuration.http_adapter = :net_http
    end

    after do
      WePay.configuration.http_adapter = :net_http
    end

    it "yields the configuration to the block" do
      described_class.configure do |config|
        config.http_adapter = :patron
      end

      expect(described_class.configuration.http_adapter).to eq(:patron)
    end
  end

  describe ".configuration" do
    it "returns the WePay configuration" do
      expect(described_class.configuration).to be_an_instance_of(WePay::Configuration)
    end
  end
end
