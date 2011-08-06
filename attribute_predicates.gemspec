$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'attribute_predicates/version'

Gem::Specification.new do |s|
  s.name              = "attribute_predicates"
  s.version           = AttributePredicates::VERSION
  s.authors           = ["Aaron Pfeifer"]
  s.email             = "aaron@pluginaweek.org"
  s.homepage          = "http://www.pluginaweek.org"
  s.description       = "Adds automatic generation of predicate methods for attributes"
  s.summary           = "Predicate methods for attributes"
  s.require_paths     = ["lib"]
  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- test/*`.split("\n")
  s.rdoc_options      = %w(--line-numbers --inline-source --title attribute_predicates --main README.rdoc)
  s.extra_rdoc_files  = %w(README.rdoc CHANGELOG.rdoc LICENSE)
  
  s.add_development_dependency("rake")
  s.add_development_dependency("plugin_test_helper", ">= 0.3.2")
end
