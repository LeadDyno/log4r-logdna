# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "log4r-logdna/version"

Gem::Specification.new do |spec|
  spec.name          = "log4r-logdna"
  spec.version       = Log4r::Logdna::VERSION
  spec.authors       = ["Mike Machado"]
  spec.email         = ["mike@leaddyno.com"]

  spec.summary       = %q{Log4r appender that outputs to LogDNA service.}
  spec.description   = %q{Log4r appender that outputs to LogDNA service.}
  spec.homepage      = "https://github.com/LeadDyno/log4r-logdna"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency("log4r", '~> 1.1.10')
  spec.add_dependency("logdna", '>= 1.0.9')

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
