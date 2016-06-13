module WePay
  class TestRequest
    include BaseRequest

    private

    def api_endpoint
      ::WePay::Client::STAGE_API_ENDPOINT
    end

    # :nocov:
    def ui_endpoint
      ::WePay::Client::STAGE_UI_ENDPOINT
    end
    # :nocov:
  end
end
