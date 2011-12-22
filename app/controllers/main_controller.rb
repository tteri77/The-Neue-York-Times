require 'net/http'
require 'rexml/document'

class MainController < ApplicationController
  
  def all
    url = "http://feeds.nytimes.com/nyt/rss/HomePage"
    xml = Net::HTTP.get_response( URI.parse( url ) )
    doc = REXML::Document.new( xml.body )
  end
  
  def index
  end
  
end
