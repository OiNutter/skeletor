unless defined? Skeletor::VERSION
  $:.unshift File.expand_path("../lib", __FILE__)
  require "skeletor/version"
end

Gem::Specification.new do |s|
  s.name = "skeletor"
  s.version = Skeletor::VERSION
  s.summary = "Gem for creating project skeletons based on YAML templates"
  s.description = "Skeletor is a Ruby Gem for creating skeleton directory structures based on a YAML template."

  s.files = Dir["README.md", "LICENSE", "lib/**/*.rb","bin/**/*","lib/skeletor/templates/**/*"]
  s.executables = ["skeletor"]
  s.authors = ["Will McKenzie"]
  s.email = ["will@oinutter.co.uk"]
  s.homepage = "http://github.com/OiNutter/skeletor"
  s.rubyforge_project = "skeletor"
  s.licenses = ["MIT"]
  
  s.add_dependency "thor"
end

