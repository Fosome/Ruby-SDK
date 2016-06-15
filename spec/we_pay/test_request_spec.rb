require 'spec_helper'

RSpec.describe WePay::TestRequest do

  describe "#response" do
    let(:client)   { double("faraday::connection") }
    let(:request)  { double("faraday::request") }
    let(:response) { double("faraday::response") }

    let(:stage_url) { "https://stage.wepayapi.com/v2" }

    let(:header_opts) do
      {
        content_type: 'application/json',
        user_agent:   'WePay Ruby SDK'
      }
    end

    let(:request_opts) do
      {
        timeout: 30
      }
    end

    let(:ssl_opts) do
      {
        verify: true
      }
    end

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
      allow(Faraday).to receive(:new).with(
        URI.parse("https://stage.wepayapi.com/v2/path"),
        headers: header_opts,
        request: request_opts,
        ssl:     ssl_opts
      ).and_return(client)

      allow(client).to receive(:post).and_yield(request).and_return(response)

      allow(request).to receive(:url).with("/v2/path")
      allow(request).to receive(:body=).with({data: 'data'}.to_json)
      allow(request).to receive(:headers).and_return({})

      expect(response).to receive(:body).and_return({ status: :ok}.to_json)
    end

    it "returns response data" do
      expect(subject.response).to eq('status' => 'ok')
    end
  end
end
