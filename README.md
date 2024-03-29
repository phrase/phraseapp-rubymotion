# phraseapp-rubymotion

phraseapp-rubymotion lets you connect your RubyMotion application to Phrase and benefit from the best internationalization workflow for your (iOS) projects.

You can use iOS Localizable.strings files to store and read translations but at the same time work on your translation files collaboratively with translators, developers and product managers.

[Learn more about Phrase](https://phrase.com/)

## Installation

Using the service requires a Phrase account. Just sign up at [phrase.com/signup](https://phrase.com/signup) and get your free trial account.

### Install the Gem

Add this line to your application's Gemfile:

    gem 'phraseapp-rubymotion'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install phraseapp-rubymotion

Require the gem (unless you use bundler):

```ruby
require 'phraseapp-rubymotion'
```

### Configure Phrase

Add the Access Token and Project ID to your application's Rakefile:

```ruby
Motion::Project::App.setup do |app|
  app.name = "Test Application"
  app.development do
    app.phraseapp do
      app.phraseapp.enabled = true
      app.phraseapp.access_token = "YOUR_ACCESS_TOKEN"
      app.phraseapp.project_id = "YOUR_PROJECT_ID"
    end
  end
end
```

You will find the Project ID in your [project settings](https://phrase.com/projects). Generate Access Tokens in your [profile settings](https://phrase.com/settings/oauth_access_tokens).

This will automatically create the `phraseapp_config.rb` configuration file in your app folder during every build process.

**Please make sure that you only enable Phrase in development mode and never in release mode!**

## Usage

Using Phrase with phraseapp-rubymotion lets you send new translations to the Phrase API automatically without having to write them into your Localizable.strings file or uploading them - just by browsing the app.

### Localizing Strings ###

The first step towards a localized app is to localize all strings by extending them with their localized counterparts. This can be done by simply calling the `#__` method on each string that is implemented by phraseapp-rubymotion:

```ruby
"Hello World"
```

now becomes:

```ruby
"Hello World".__
```

or (when using a fallback translation):

```ruby
"Hello World".__("My fallback translation")
```

Of course you can use more generic names for your keys as well, such as:

```ruby
"HOME_WELCOME_BUTTON_LABEL".__
```

[Learn more about localization in iOS](https://developer.apple.com/internationalization/)

### Browsing translations in your app

Simply build and run your app (in the simulator). When in development mode, phraseapp-rubymotion will send all of your localized strings to PhraseApp automatically! Log into your [Phrase account](https://phrase.com/account/login) and check your newly created keys. If you already have your localization files in the correct place, it will transmit translations as well.

## Support

* [Phrase Documentation](https://help.phrase.com/)
* [Phrase Support](https://phrase.com/contact)

## Get help / support

Please contact [support@phrase.com](mailto:support@phrase.com?subject=[GitHub]%20) and we can take more direct action toward finding a solution.
