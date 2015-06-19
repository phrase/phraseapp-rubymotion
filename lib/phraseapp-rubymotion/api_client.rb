module MotionPhrase
  class ApiClient
    API_CLIENT_IDENTIFIER = "PhraseApp RubyMotion " + MotionPhrase::VERSION
    API_BASE_URI = "https://api.phraseapp.com/v2/"

    def self.sharedClient
      Dispatch.once { @instance ||= new }
      @instance
    end

    def storeTranslation(keyName, content, fallbackContent, currentLocale)
      return unless access_token_present? && project_id_present?

      content ||= fallbackContent
      data = {
        name: keyName
      }

      client.POST("projects/#{project_id}/keys", parameters:data, success:lambda {|task, responseObject|
        log "TranslationKey stored [#{data.inspect}]"
      }, failure:lambda {|task, error|
        if error.userInfo['com.alamofire.serialization.response.error.data'].to_s.include?('has already been taken')
          log "TranslationKey '#{keyName}'' is already stored"
        else
          log "Error while storing TranslationKey [#{data.inspect}]"
          log error.localizedDescription
        end
      })

      default_locale
    end

  private
    def client
      Dispatch.once do
        @client = begin
          _client = AFHTTPSessionManager.alloc.initWithBaseURL(NSURL.URLWithString(API_BASE_URI))
          _client.requestSerializer.setValue("token #{access_token}", forHTTPHeaderField: "Authorization")
          _client
        end
      end
      @client
    end

    def log(msg="")
      $stdout.puts "PHRASEAPP #{msg}"
    end

    def access_token
      if defined?(PHRASEAPP_ACCESS_TOKEN)
        PHRASEAPP_ACCESS_TOKEN
      else
        nil
      end
    end

    def access_token_present?
      !access_token.nil? && access_token != ""
    end

    def project_id
      if defined?(PHRASEAPP_PROJECT_ID)
        PHRASEAPP_PROJECT_ID
      else
        nil
      end
    end    

    def project_id_present?
      !project_id.nil? && project_id != ""
    end

    def default_locale
      resp = client.GET(
        "projects/#{project_id}/locales",
        parameters:nil, 
        success: lambda {|task, responseObject|
          responseObject.each do |locale|
            if locale['default']
              return locale['id'].to_s
            end
          end
        },
        failure:lambda {|task, error|
          return "failuire"
      })
      
    end

    def default_locale_present?
      default_locale != ""
    end

  end
end
