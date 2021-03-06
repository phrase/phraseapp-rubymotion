# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'phraseapp-rubymotion/version'

Gem::Specification.new do |gem|
  gem.name          = "phraseapp-rubymotion"
  gem.version       = MotionPhrase::VERSION
  gem.authors       = ["PhraseApp"]
  gem.email         = ["info@phraseapp.com"]
  gem.description   = "RubyMotion library for PhraseApp"
  gem.summary       = "Connect your RubyMotion application to PhraseApp for the best i18n experience"
  gem.homepage      = "https://github.com/phrase/phraseapp-rubymotion"
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency 'phraseapp-ruby'
  gem.add_dependency 'motion-cocoapods'
  gem.add_development_dependency 'rake'
end
