module MotionPhrase
  class ApiClient
    API_CLIENT_IDENTIFIER = "PhraseApp RubyMotion " + MotionPhrase::VERSION
    API_BASE_URI = "https://api.phraseapp.com/v2/"

    def self.sharedClient
      Dispatch.once { @instance ||= new }
      @instance
    end

    def storeTranslation(keyName, content, fallbackContent, currentLocale)
      return unless auth_token_present?

      content ||= fallbackContent
      data = {
        key: keyName,
      }

      client.POST("projects/" + project_id + "/keys", parameters:data, success:lambda {|task, responseObject|
        log "Translation stored [#{data.inspect}]"
      }, failure:lambda {|task, error|
        log "Error while storing translation [#{data.inspect}]"
        log error.localizedDescription
      })
    end

  private
    def client
      Dispatch.once do
        @client = begin
          _client = AFHTTPSessionManager.alloc.initWithBaseURL(NSURL.URLWithString(API_BASE_URI)) do
            header "Authorized", "token " + auth_token
            header "User-Agent", API_CLIENT_IDENTIFIER
          end
          _client
        end
      end
      @client
    end

    def log(msg="")
      $stdout.puts "PHRASEAPP #{msg}"
    end

    def auth_token
      if defined?(PHRASE_AUTH_TOKEN)
        PHRASE_AUTH_TOKEN
      else
        nil
      end
    end

    def auth_token_present?
      !auth_token.nil? && auth_token != ""
    end

    def project_id
      if defined?(PHRASE_PROJECT_ID)
        PHRASE_PROJECT_ID
      else
        nil
      end
    end    

    def project_id_present?
      !project_id.nil? && project_id != ""
    end

  end
end
