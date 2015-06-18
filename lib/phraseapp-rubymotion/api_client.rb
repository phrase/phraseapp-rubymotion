module MotionPhrase
  class ApiClient
    API_CLIENT_IDENTIFIER = "PhraseApp RubyMotion " + MotionPhrase::VERSION
    API_BASE_URI = "https://api.phraseapp.com/v2/"

    def self.sharedClient
      Dispatch.once { @instance ||= new }
      @instance
    end

    def storeTranslation(keyName, content, fallbackContent, currentLocale)
      return unless access_token_present?

      content ||= fallbackContent
      data = {
        name: keyName
      }

      client.POST("projects/#{project_id}/keys", parameters:data, success:lambda {|task, responseObject|
        log "Translation stored [#{data.inspect}]"
      }, failure:lambda {|task, error|
        log "Error while storing translation [#{data.inspect}]"
        log error.localizedDescription
        log error.userInfo
      })
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

  end
end
