require 'json'
require 'net/http'
require 'net/https'
require 'uri'

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
      @raw_response ||= client.start do |c|
        c.request(request)
      end
    end

    def request
      @request ||= Net::HTTP::Post.new(uri.path, default_headers).tap do |r|
        if params.any?
          r.body = params.to_json
        end

        if access_token
          r.add_field('Authorization', "Bearer #{access_token}")
        end

        if api_version
          r.add_field('Api-Version', @api_version)
        end
      end
    end

    def client
      @client ||= Net::HTTP.new(uri.host, uri.port).tap do |c|
        c.read_timeout = 30
        c.use_ssl      = true
      end
    end

    def uri
      @uri ||= URI.join(api_endpoint, normalized_path)
    end

    def normalized_path
      return path if path.start_with?('/')

      path.prepend('/')
    end

    def default_headers
      {
        'Content-Type' => 'application/json',
        'User-Agent'   => 'WePay Ruby SDK'
      }
    end
  end
end
