class NSString
  def _localized(value=nil, table=nil)
    @localized = NSBundle.mainBundle.localizedStringForKey(self, value:value, table:table)
    store(self, @localized, value, table) if phraseEnabled?
    @localized
  end
  alias __ _localized

private
  def store(key, localized, defaultValue=nil, table=nil)
    @client = MotionPhrase::ApiClient.sharedClient
    @client.store(key, localized, defaultValue, currentLocaleName)
  end

  def phraseEnabled?
    PHRASEAPP_ENABLED == true && development?
  end

  def currentLocaleName
    currentLocale.localeIdentifier
  end

  # @return [NSLocale] locale of user settings
  def currentLocale
    languages = NSLocale.preferredLanguages
    if languages.count > 0
      return NSLocale.alloc.initWithLocaleIdentifier(languages.first)
    else
      return NSLocale.currentLocale
    end
  end

  def environment
    RUBYMOTION_ENV
  end

  def development?
    environment == 'development'
  end

end
