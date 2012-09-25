# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "radiant-relations-extension"

Gem::Specification.new do |s|
  s.name        = "radiant-relations-extension"
  s.version     = RadiantRelationsExtension::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jan De Poorter", "Benny Degezelle"]
  s.email       = ["rubygems@monkeypatch.be"]
  s.homepage    = "http://github.com/jomz/radiant-relations-extension"
  s.summary     = %q{Relations extension for Radiant CMS}
  s.description = %q{Allows you to define relations between pages}
  
  ignores = if File.exist?('.gitignore')
    File.read('.gitignore').split("\n").inject([]) {|a,p| a + Dir[p] }
  else
    []
  end
  s.files         = Dir['**/*'] - ignores
  s.test_files    = Dir['test/**/*','spec/**/*','features/**/*'] - ignores
  # s.executables   = Dir['bin/*'] - ignores
  s.require_paths = ["lib"]
  
  s.post_install_message = %{
    Add this to your radiant project by putting this line in your Gemfile:
      gem "radiant-children_config-extension", "~> #{RadiantRelationsExtension::VERSION}"
  }
end