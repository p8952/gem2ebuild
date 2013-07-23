# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gem2ebuild/version'

Gem::Specification.new do |gem|
  gem.name          = 'gem2ebuild'
  gem.version       = Gem2ebuild::VERSION
  gem.authors       = ['Peter Wilmott']
  gem.email         = ['p@p8952.info']
  gem.description   = 'description'
  gem.summary       = 'summary'
  gem.homepage      = 'https://github.com/p8952/gem2ebuild'
  gem.license       = 'GPL-3'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency('gems')
  gem.add_dependency('rspec')
end
