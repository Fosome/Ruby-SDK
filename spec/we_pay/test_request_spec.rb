require 'spec_helper'

RSpec.describe WePay::TestRequest do

  describe "#response" do
    let(:http_response) { double("net::http::response") }
    let(:http_post)     { double("net::http::post") }
    let(:http_client)   { double("net::http") }

    subject do
      described_class.new(
        'client_id',
        'client_secret',
        'api_version',
        'path',
        'access_token',
        data: 'data'
      )
    end

    before do
      allow(http_response).to receive(:body).and_return({ response: 'response' }.to_json)

      allow(Net::HTTP::Post).to receive(:new).with(
          "/path",
          'Content-Type' => 'application/json',
          'User-Agent'   => 'WePay Ruby SDK'
        ).and_return(http_post)

      allow(http_post).to receive(:body=).with({ data: 'data' }.to_json)
      allow(http_post).to receive(:add_field).with('Authorization', "Bearer access_token")
      allow(http_post).to receive(:add_field).with('Api-Version', "api_version")

      allow(Net::HTTP).to receive(:new).with(
          "stage.wepayapi.com",
          443
        ).and_return(http_client)

      allow(http_client).to receive(:read_timeout=).with(30)
      allow(http_client).to receive(:use_ssl=).with(true)
      allow(http_client).to receive(:request).with(http_post).and_return(http_response)
      allow(http_client).to receive(:start).and_yield(http_client)
    end

    it "returns response data" do
      expect(subject.response).to eq({ 'response' => 'response' })
    end
  end
end
