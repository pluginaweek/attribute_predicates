# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{attribute_predicates}
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Aaron Pfeifer"]
  s.date = %q{2010-03-07}
  s.description = %q{Adds automatic generation of predicate methods for attributes}
  s.email = %q{aaron@pluginaweek.org}
  s.files = ["lib/attribute_predicates", "lib/attribute_predicates/extensions", "lib/attribute_predicates/extensions/module.rb", "lib/attribute_predicates/extensions/active_record.rb", "lib/attribute_predicates.rb", "test/active_record_test.rb", "test/test_helper.rb", "test/module_test.rb", "CHANGELOG.rdoc", "init.rb", "LICENSE", "Rakefile", "README.rdoc"]
  s.homepage = %q{http://www.pluginaweek.org}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{pluginaweek}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Adds automatic generation of predicate methods for attributes}
  s.test_files = ["test/active_record_test.rb", "test/module_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
