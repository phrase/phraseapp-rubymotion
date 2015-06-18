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
