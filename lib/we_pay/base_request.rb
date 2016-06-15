require 'json'
require 'uri'
require 'faraday'

module WePay
  module BaseRequest

    attr_reader :client_id,
                :client_secret,
                :api_version,
                :path,
                :access_token,
                :params

    def initialize(client_id, client_secret, api_version, path, access_token, params)
      @client_id     = client_id
      @client_secret = client_secret
      @api_version   = api_version
      @path          = path
      @access_token  = access_token
      @params        = params
    end

    def response
      JSON.parse(raw_response.body)
    end

    private

    def raw_response
      @raw_response ||= client.post do |r|
        r.url(uri.path)

        if params.any?
          r.body = params.to_json
        end

        if access_token
          r.headers['Authorization'] = "Bearer #{access_token}"
        end

        if api_version
          r.headers['Api-Version'] = api_version
        end
      end
    end

    def client
      @client ||= Faraday.new(
        uri,
        headers: default_headers,
        request: default_request_opts,
        ssl:     default_ssl_opts
      )
    end

    def normalized_path
      return path if path.start_with?('/')

      path.prepend('/')
    end

    def uri
      URI.parse(api_endpoint + normalized_path)
    end

    def default_headers
      {
        content_type: 'application/json',
        user_agent:   'WePay Ruby SDK'
      }
    end

    def default_request_opts
      {
        timeout: 30
      }
    end

    def default_ssl_opts
      { 
        verify: true
      }
    end
  end
end
