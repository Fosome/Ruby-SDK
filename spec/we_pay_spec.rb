require 'spec_helper'

RSpec.describe WePay do

  describe ".configuration" do
    it "returns the WePay configuration" do
      expect(described_class.configuration).to be_an_instance_of(WePay::Configuration)
    end
  end
end
