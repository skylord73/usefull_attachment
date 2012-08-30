# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
require File.expand_path('../lib/usefull_attachment/version', __FILE__)

Gem::Specification.new do |s|
  s.authors          = ["Andrea Bignozzi"]
  s.email            = ["skylord73@gmail.com"]
  s.description      = "Describe Gem Here"
  s.summary          = "Describe Gem Here"
  
  s.files            = Dir["{app,lib,config,bin}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.md", "CHANGELOG.md"]
  s.executables      = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files       = s.files.grep(%r{^(test|spec|features)/})
  s.name             = "usefull_attachment"
  s.require_paths    = ["lib"]
  s.version          = UsefullAttachment::VERSION
  
  s.add_dependency "rails", "~>3.0.15"
  s.add_dependency "acts_as_monitor"
  s.add_dependency "paperclip"
  s.add_dependency "usefull_filter"
  s.add_dependency "usefull_table"
  s.add_dependency "will_paginate"

end

