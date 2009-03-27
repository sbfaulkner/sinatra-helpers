# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sinatra-helpers}
  s.version = "0.9.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["S. Brent Faulkner"]
  s.date = %q{2009-03-27}
  s.description = %q{a bunch of useful helpers for sinatra applications}
  s.email = %q{brentf@unwwwired.net}
  s.files = ["README.rdoc", "VERSION.yml", "lib/sinatra-helpers", "lib/sinatra-helpers/haml", "lib/sinatra-helpers/haml/flash.rb", "lib/sinatra-helpers/haml/forms.rb", "lib/sinatra-helpers/haml/links.rb", "lib/sinatra-helpers/haml/partials.rb", "lib/sinatra-helpers/haml.rb", "lib/sinatra-helpers/html", "lib/sinatra-helpers/html/escape.rb", "lib/sinatra-helpers/html.rb", "lib/sinatra-helpers.rb", "test/haml", "test/haml/flash_test.rb", "test/haml/forms_test.rb", "test/haml/links_test.rb", "test/haml/partials_test.rb", "test/haml/views", "test/haml/views/_object.haml", "test/haml/views/_thing.haml", "test/html", "test/html/escape_test.rb", "test/test_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/sbfaulkner/sinatra-helpers}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{a bunch of useful helpers for sinatra applications}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
