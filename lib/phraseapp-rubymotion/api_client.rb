module MotionPhrase
  class ApiClient
    API_CLIENT_IDENTIFIER = "Phrase RubyMotion " + MotionPhrase::VERSION
    API_BASE_URI = "https://api.phrase.com/v2/"

    def self.sharedClient
      Dispatch.once { @instance ||= new }
      @instance
    end

    def store(keyName, content, fallbackContent, currentLocale)
      return unless access_token_present? && project_id_present?
      content ||= fallbackContent
      client.GET("projects/#{project_id}/locales", parameters:{}, success:lambda {|task, responseObject|
        responseObject.each do |x|
          if x["default"]
            locale_id = x["id"]
            storeKey({name: keyName}, locale_id, content, keyName)
          end
        end
      }, failure:lambda {|task, error|
        log "Failed to get locales"
      })
    end

    def storeKey(data, locale_id, content, keyName)
      client.POST("projects/#{project_id}/keys", parameters:data, success:lambda {|task, responseObject|
        log "Key stored [#{data.inspect}]"
        
        client.POST("projects/#{project_id}/keys/search", parameters:{q: "name:#{keyName}"}, success:lambda {|task, responseObject|
          storeTranslation(content, locale_id, responseObject[0]["id"])
        }, failure:lambda {|task, error|
          log "Failed to get KeyID [#{data.inspect}]"
        })
      }, failure:lambda {|task, error|
        if error.userInfo['com.alamofire.serialization.response.error.data'].to_s.include?('has already been taken')
          log "Key [#{data.inspect}] is already stored"
          
          client.POST("projects/#{project_id}/keys/search", parameters:{q: "name:#{keyName}"}, success:lambda {|task, responseObject|
            storeTranslation(content, locale_id, responseObject[0]["id"])
          }, failure:lambda {|task, error|
            log "Failed to get KeyID [#{data.inspect}]"
          })
        else
          log "Error while storing Key [#{data.inspect}]"
          log error.localizedDescription
        end
      })
    end

    def storeTranslation(content, locale_id, key_id)
      data = {
        content: content,
        locale_id: locale_id,
        key_id: key_id
      }
      client.POST("projects/#{project_id}/translations", parameters:data, success:lambda {|task, responseObject|
        log "Translation stored [#{data.inspect}]"
      }, failure:lambda {|task, error|
        if error.userInfo['com.alamofire.serialization.response.error.data'].to_s.include?('has already been taken')
          log "Translation is already stored [#{data.inspect}] "
        else
          log "Error while storing Translation [#{data.inspect}]"
          log error.localizedDescription
        end
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
      $stdout.puts "PHRASEAPP: #{msg}"
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
