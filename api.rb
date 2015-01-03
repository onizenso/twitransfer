require 'httparty'
require 'oauth'

class TwiTransfer
  include HTTParty

  def get_access_token(oauth_token, oauth_token_secret)
    consumer = OAuth::Consumer.new("APIKey", "APISecret", 
                                  { :site => "https://api.twitter.com", 
                                    :scheme => :header })
     
    # now create the access token object from passed values
    token_hash = { :oauth_token => oauth_token, 
                   :oauth_token_secret => oauth_token_secret }
    access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
 
    return access_token
  end 
end
