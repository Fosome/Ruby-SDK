Gem::Specification.new do |s|
  s.name        = "wepay"
  s.version     = "0.3.0"
  s.authors     = ["WePay"]
  s.email       = "api@wepay.com"
  s.date        = "2016-06-11"

  s.summary     = "WePay SDK for Ruby"
  s.description = "The WePay SDK for Ruby lets you easily make WePay API calls from Ruby."
  s.homepage    = "https://github.com/wepay/Ruby-SDK"
  s.license     = "Apache-2.0"

  s.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.test_files  = Dir["spec/**/*"]

  s.add_dependency "faraday", ">= 0.9.0"

  s.add_development_dependency "bundler", "~> 1.12"
  s.add_development_dependency "rake",    "~> 10.0"
  s.add_development_dependency "rspec",   "~> 3.0"

  s.add_development_dependency "simplecov"
  s.add_development_dependency "codeclimate-test-reporter"
  s.add_development_dependency "coveralls"
  s.add_development_dependency "scrutinizer-ocular"

  s.add_development_dependency "yard"
  s.add_development_dependency "yard-sitemap"
  s.add_development_dependency "rdiscount"
end
