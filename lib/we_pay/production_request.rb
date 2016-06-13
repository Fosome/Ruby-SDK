module WePay
  class ProductionRequest
    include BaseRequest

    private

    def api_endpoint
      ::WePay::Client::PRODUCTION_API_ENDPOINT
    end

    # :nocov:
    def ui_endpoint
      ::WePay::Client::PRODUCTION_UI_ENDPOINT
    end
    # :nocov:
  end
end
