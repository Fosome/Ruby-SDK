##
# Copyright (c) 2012-2016 WePay.
#
# http://opensource.org/licenses/Apache2.0
##

require 'cgi'
require 'json'
require 'net/http'
require 'net/https'

module WePay

  ##
  # A very simple wrapper for the WePay API.
  ##
  class Client

    # Stage API endpoint
    STAGE_API_ENDPOINT = "https://stage.wepayapi.com/v2"

    # Stage UI endpoint
    STAGE_UI_ENDPOINT = "https://stage.wepay.com/v2"

    # Production API endpoint
    PRODUCTION_API_ENDPOINT = "https://wepayapi.com/v2"

    # Production UI endpoint
    PRODUCTION_UI_ENDPOINT = "https://www.wepay.com/v2"

    attr_reader :client_id,
                :client_secret,
                :use_stage,
                :api_version

    def initialize(client_id, client_secret, use_stage = true, api_version = nil)
      @client_id     = client_id.to_s
      @client_secret = client_secret.to_s
      @use_stage     = !!use_stage
      @api_version   = api_version.to_s
    end

    ##
    # Execute a call to the WePay API.
    ##
    def call(path, access_token = false, params = {})
      request_class.new(
        client_id,
        client_secret,
        api_version,
        path,
        access_token,
        params
      ).response
    end

    ##
    # Returns the OAuth 2.0 URL that users should be redirected to for
    # authorizing your API application. The `redirect_uri` must be a
    # fully-qualified URL (e.g., `https://www.wepay.com`).
    ##
    def oauth2_authorize_url(
      redirect_uri,
      user_email   = false,
      user_name    = false,
      permissions  = default_oauth_permissions,
      user_country = false
    )
      url = ui_endpoint +
            '/oauth2/authorize?client_id=' + @client_id.to_s +
            '&redirect_uri=' + redirect_uri +
            '&scope=' + permissions

      url += user_name ?    '&user_name='    + CGI::escape(user_name)    : ''
      url += user_email ?   '&user_email='   + CGI::escape(user_email)   : ''
      url += user_country ? '&user_country=' + CGI::escape(user_country) : ''
    end

    ##
    # Call the `/v2/oauth2/token` endpoint to exchange an OAuth 2.0 `code` for an `access_token`.
    ##
    def oauth2_token(code, redirect_uri)
      call('/oauth2/token', false, {
        'client_id'     => @client_id,
        'client_secret' => @client_secret,
        'redirect_uri'  => redirect_uri,
        'code'          => code
      })
    end

    ##
    # Support exisiting API
    #
    # `WePay::Client#api_endpoint`
    ##
    def api_endpoint
      if use_stage
        STAGE_API_ENDPOINT
      else
        PRODUCTION_API_ENDPOINT
      end
    end

    ##
    # Support exisiting API
    #
    # `WePay::Client#ui_endpoint`
    ##
    def ui_endpoint
      if use_stage
        STAGE_UI_ENDPOINT
      else
        PRODUCTION_UI_ENDPOINT
      end
    end

    private

    def request_class
      if use_stage
        TestRequest
      else
        ProductionRequest
      end
    end

    def default_oauth_permissions
      %w(
        manage_accounts
        collect_payments
        view_user
        send_money
        preapprove_payments
        manage_subscriptions
      ).join(',')
    end
  end
end
