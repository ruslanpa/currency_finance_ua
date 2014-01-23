# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'currency_finance_ua/version'

Gem::Specification.new do |spec|
  spec.name          = "currency_finance_ua"
  spec.version       = CurrencyFinanceUA::VERSION
  spec.authors       = ["ruslanpa"]
  spec.email         = ["ruslan.pavlutskiy@gmail.com"]
  spec.description   = %q{It's a simple wrapper under <http://content.finance.ua/ru/xml/currency-cash>}
  spec.homepage      = "https://github.com/ruslanpa/currency_finance_ua"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
