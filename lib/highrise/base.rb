require File.dirname(__FILE__) + '/../cachable'

module Highrise
  class Base < ActiveResource::Base
    include ::Cachable
    
    # Provides access to account information. 
    # See http://developer.37signals.com/highrise/account
    def self.account
      find(:one, :from => "/account.xml")
    end
    
    # Permits API-key retrieval using name and password.
    #     Highrise::User.site = "https://yourcompany.highrise.com"
    #     Highrise::User.user = "your_user_name"
    #     Highrise::User.password = "s3kr3t"
    #     Highrise::User.me.token # contains the API token for "your_user_name"  
    def self.me
      find(:one, :from => "/me.xml")
    end
    
    def self.recordings(since_date)
      result = find(:all, {:from => "/recordings.xml", 
        :params => {
          :since => since_date.highrise_format
        }
      })
      
      last_result = result
      while last_result.length > 0
        last_result = find(:all, {:from => "/recordings.xml", 
          :params => {
            :since => since_date.highrise_format, 
            :n => result.length
          }
        })
        result = result + last_result
      end
            
      result
    end
  end
end
