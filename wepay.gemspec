Gem::Specification.new do |s|
  s.name        = 'wepay'
  s.version     = '0.3.0'
  s.date        = '2016-06-11'

  s.summary     = "WePay SDK for Ruby"
  s.description = "The WePay SDK for Ruby lets you easily make WePay API calls from Ruby."
  s.authors     = ["WePay"]
  s.email       = 'api@wepay.com'
  s.homepage    = 'https://github.com/wepay/Ruby-SDK'
  s.license     = 'Apache-2.0'

  s.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
end
