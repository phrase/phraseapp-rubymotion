unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

require "motion/project/phrase"
require "motion-cocoapods"
require "phraseapp-ruby"

Motion::Project::App.setup do |app|
  Dir.glob(File.join(File.dirname(__FILE__), 'phraseapp-rubymotion/**/*.rb')).each do |file|
    app.files.unshift(file)
  end

  app.files.unshift("./app/phrase_config.rb")
  
  app.pods do
    pod 'AFNetworking', '>= 2.5.0'
  end
end

namespace :phrase do
  desc "Initialize PhraseApp for your RubyMotion project"
  task :init do
    access_token = ENV['AUTH_TOKEN']
    App.fail "Please specify your auth token, e.g. rake phrase:init AUTH_TOKEN=secret" unless access_token
    result = `phrase init --secret=#{access_token}`
    App.info "PHRASE", result
  end

  desc "Push your Localizable.strings files to PhraseApp"
  task :push do
    result = `phrase push --recursive ./resources`
    App.info "PHRASE", result
  end

  desc "Pull your current localization files files from PhraseApp"
  task :pull do
    result = `phrase pull --target=resources --format=strings`
    App.info "PHRASE", result
  end
end
