require 'spec_helper'

RSpec.describe WePay::Client do

  context "constants" do
    it "returns the staging api endpoint" do
      expect(described_class::STAGE_API_ENDPOINT).to eq('https://stage.wepayapi.com/v2')
    end

    it "returns the staging ui endpoint" do
      expect(described_class::STAGE_UI_ENDPOINT).to eq('https://stage.wepay.com/v2')
    end

    it "returns the production api endpoint" do
      expect(described_class::PRODUCTION_API_ENDPOINT).to eq('https://wepayapi.com/v2')
    end

    it "returns the production ui endpoint" do
      expect(described_class::PRODUCTION_UI_ENDPOINT).to eq('https://www.wepay.com/v2')
    end
  end

  context "an instance" do
    subject do
      described_class.new(
        'client_id',
        'client_secret'
      )
    end

    describe "#initialize" do
      it "returns a client" do
        expect(subject).to be_a(described_class)
      end
    end

    describe "#api_endpoint" do
      context "for non-production environments" do
        subject do
          described_class.new(
            'client_id',
            'client_secret',
            true
          )
        end

        it "returns the stage api endpoint" do
          expect(subject.api_endpoint).to eq('https://stage.wepayapi.com/v2')
        end
      end

      context "for production environments" do
        subject do
          described_class.new(
            'client_id',
            'client_secret',
            false
          )
        end

        it "returns the production api endpoint" do
          expect(subject.api_endpoint).to eq('https://wepayapi.com/v2')
        end
      end
    end

    describe "#api_version" do
      context "when no version is given" do
        it "returns nothing" do
          expect(subject.api_version).to eq('')
        end
      end

      context "when a version is given" do
        subject do
          described_class.new(
            'client_id',
            'client_secret',
            true,
            1
          )
        end

        it "returns the version" do
          expect(subject.api_version).to eq('1')
        end
      end
    end

    describe "#client_id" do
      it "returns the client id" do
        expect(subject.client_id).to eq('client_id')
      end
    end

    describe "#client_secret" do
      it "returns the client secret" do
        expect(subject.client_secret).to eq('client_secret')
      end
    end

    describe "#ui_endpoint" do
      context "for non-production environments" do
        subject do
          described_class.new(
            'client_id',
            'client_secret',
            true
          )
        end

        it "returns the staging ui endpoint" do
          expect(subject.ui_endpoint).to eq('https://stage.wepay.com/v2')
        end
      end

      context "for production environments" do
        subject do
          described_class.new(
            'client_id',
            'client_secret',
            false
          )
        end

        it "returns the production ui endpoint" do
          expect(subject.ui_endpoint).to eq('https://www.wepay.com/v2')
        end
      end
    end

    describe "#call" do
      context "making a non-production request" do
        subject do
          described_class.new(
            'client_id',
            'client_secret'
          )
        end

        let(:request) { double("wepay::test_request") }

        it "makes a staging request" do
          allow(WePay::TestRequest).to receive(:new)
            .with(
              'client_id',
              'client_secret',
              '',
              '/app',
              false,
              {}
            ).and_return(request)

          expect(request).to receive(:response)

          subject.call('/app')
        end
      end

      context "making a production request" do
        subject do
          described_class.new(
            'client_id',
            'client_secret',
            false
          )
        end

        let(:request) { double("wepay::production_request") }

        it "makes a production request" do
          allow(WePay::ProductionRequest).to receive(:new)
            .with(
              'client_id',
              'client_secret',
              '',
              '/app',
              false,
              {}
            ).and_return(request)

          expect(request).to receive(:response)

          subject.call('/app')
        end
      end
    end

    describe "#oauth2_authorize_url" do
      context "with default params" do
        it "returns the oauth2 authorize url" do
          expect(
            subject.oauth2_authorize_url(
              'https://www.wepay.com'
            )
          ).to eq(
            'https://stage.wepay.com/v2/oauth2/authorize?client_id=client_id&redirect_uri=https://www.wepay.com&scope=manage_accounts,collect_payments,view_user,send_money,preapprove_payments,manage_subscriptions')
        end
      end

      context "with custom params" do
        it "returns the oauth2 authorize url" do
          expect(
            subject.oauth2_authorize_url(
              'https://www.wepay.com',
              'user@host.com',
              'username',
              'manage_accounts',
              'US United States'
            )
          ).to eq(
            'https://stage.wepay.com/v2/oauth2/authorize?client_id=client_id&redirect_uri=https://www.wepay.com&scope=manage_accounts&user_name=username&user_email=user%40host.com&user_country=US+United+States')
        end
      end
    end

    describe "#oauth2_token" do
      subject do
        described_class.new(
          'client_id',
          'client_secret',
          false
        )
      end

      let(:request) { double("wepay::production_request") }

      it "returns a oauth2 token response" do
        allow(WePay::ProductionRequest).to receive(:new)
          .with(
            'client_id',
            'client_secret',
            '',
            '/oauth2/token',
            false,
            {
              'client_id'     => 'client_id',
              'client_secret' => 'client_secret',
              'redirect_uri'  => 'https://redirect.app.com',
              'code'          => 'code'

            }
          ).and_return(request)

        expect(request).to receive(:response)
        subject.oauth2_token('code', 'https://redirect.app.com')
      end
    end
  end
end
