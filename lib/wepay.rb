##
# Copyright (c) 2012-2016 WePay.
#
# http://opensource.org/licenses/Apache2.0
##

##
# The root WePay namespace.
##
module WePay
  autoload :Client,      'we_pay/client'

  autoload :BaseRequest,       'we_pay/base_request'
  autoload :TestRequest,       'we_pay/test_request'
  autoload :ProductionRequest, 'we_pay/production_request'
end
