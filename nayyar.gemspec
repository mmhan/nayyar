# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nayyar/version'

Gem::Specification.new do |spec|
  spec.name          = "nayyar"
  spec.version       = Nayyar::VERSION
  spec.authors       = ["mmhan"]
  spec.email         = ["mmhan2u@gmail.com"]

  spec.summary       = %q{Nayyar gives you access to State/Regions, Districts and Townships of Myanmar.}
  spec.description   = %q{Nayyar is created with the intent of providing basic access to State/Regions, Districts or Townships of Myanmar, based on standards of Myanmar's country-wide census of 2014.

15 States are indexed by MIMU's pcode, ISO3166-2:MM and alpha3 codes used in plate numbers by transportation authority.
74 Districts and 413 Townships are indexed by MIMU's pcode.

The current version is `0.1.0` and it uses [Semantic Versioning](http://semver.org/)}
  spec.homepage      = "https://github.com/mmhan/nayyar"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec', '>= 3'
  spec.add_development_dependency 'pry', '>= 0.10'
end
