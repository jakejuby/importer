# gemspec.rb

require File.expand_path("../lib/newgem/version", __FILE__)

Gem::Specification.new do |s|

s.name        = "importer"

s.version     = NewGem::VERSION

s.platform    = Gem::Platform::RUBY

s.authors     = ["Jacob Juby"]

s.email       = ["jakejuby@gmail.com"]

s.homepage    = "https://github.com/Jacob-Juby/importer"

s.summary     = "A gem for importing"

s.description = "A gem that helps with legacy data, or reducing data redundancy"

s.required_rubygems_version = "&gt;= 1.3.6"

# required for validation

s.rubyforge_project         = "importer"

# If you have other dependencies, add them here

# s.add_dependency "another", "~&gt; 1.2"

# If you need to check in files that aren't .rb files, add them here

s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]

s.require_path = 'lib'

# If you need an executable, add it here

# s.executables = ["newgem"]

# If you have C extensions, uncomment this line

# s.extensions = "ext/extconf.rb"

end
