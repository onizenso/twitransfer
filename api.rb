#!/usr/bin/env ruby

require 'httparty'
require 'pry'
require 'bundler/setup'
require 'oauth'

class TwiTransfer
  include HTTParty
  attr_accessor :base_uri,:base_path,:version
  # === initialialize(uri,path,params={})
  # Set the api key/secret, and the oauth token/secret
  # using the respective strings set in environment variables.
  # 
  # Set the parameter options for the supplied path, the options will depend
  # on what portion of the API the app is accessing.
  #
  # Example: path='friends/list.json'
  # params={:user_id => '12345',
  #         :screen_name => 'Twitransfers',
  #         :cursor => '12893764510938',
  #         :count => '42',
  #         :skip_status => [true || t || 1 || false || f || 0],
  #         include_user_entities => [true || false] }
  #
  def initialize(uri='', path='' ,params={})
    #@options = { query: {site: service, page: page} }
    @api_key = ENV['TW_API'].to_s
    @api_secret = ENV['TW_API_SECRET'].to_s
    @oauth_tkn = ENV['TW_OAUTH'].to_s
    @oauth_tkn_secret = ENV['TW_OAUTH_SECRET'].to_s
    @base_uri = uri
    @version = '1.1'
    @base_path = path
    @params=params
  end

  def get_access_token(oauth_token=@oauth_tkn, 
                       oauth_token_secret=@oauth_tkn_secret)
    consumer = OAuth::Consumer.new(@api_key, @api_secret, 
                                  { :site => @base_uri, 
                                    :scheme => :header })
     
    # now create the access token object from passed values
    token_hash = { :oauth_token => oauth_token, 
                   :oauth_token_secret => oauth_token_secret }
    access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
    access_token
  end
 
  def access_request(token,method,path='',options={})
    path = @base_path if path.empty?
    opts = []
    options.each {|key, val| opts << "#{key}=#{val}"}
    opts = opts.join('&')
    token.request(method, "#{@base_uri}/#{@version}/#{path}?#{opts}")
  end
end

uri = 'https://api.twitter.com'
path = 'friends/list.json'
twit = TwiTransfer.new(uri,path)
access = twit.get_access_token
options ={:screen_name => 'Twitransfers',
          :cursor => '-1',
          :count => '15',
          :skip_status => true,
          :include_user_entities => false }

response = twit.access_request(access,:get,'',options)
