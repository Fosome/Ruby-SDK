require 'spec_helper'

RSpec.describe WePay::Configuration do

  subject { described_class.instance }

  describe "as a singleton" do
    it "returns an instance" do
      expect(described_class.instance).to be_an_instance_of(described_class)
    end
  end

  describe "#http_adapter" do
    context "by default" do
      it "returns Net Http" do
        expect(subject.http_adapter).to eq(:net_http)
      end
    end

    context "with an explicit adapter" do
      before do
        subject.http_adapter = :patron
      end

      after do
        subject.http_adapter = nil
      end

      it "returns the adapter" do
        expect(subject.http_adapter).to eq(:patron)
      end
    end
  end
end
