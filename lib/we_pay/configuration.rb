require 'singleton'

module WePay
  class Configuration
    include ::Singleton

    attr_writer :http_adapter

    def http_adapter
      @http_adapter || default_http_adapter
    end

    private

    def default_http_adapter
      :net_http
    end
  end
end
