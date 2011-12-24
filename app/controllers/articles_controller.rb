require 'net/http'
require 'rexml/document'

class Item
  attr_accessor :title
  attr_accessor :description
  attr_accessor :url
  attr_accessor :tags
  
  def clean_description
    while @description.index( "<" )
      @description = @description.chop
    end
  end
    
end

class Tag
  attr_accessor :url
  attr_accessor :name
end

class ArticlesController < ApplicationController
  
  def get_items
    # create the @items instance variable.
    items = []
    
    # go and get the xml.
    url = "http://feeds.nytimes.com/nyt/rss/HomePage" # define the url.
    xml = Net::HTTP.get_response( URI.parse( url ) ) # get the xml.
    doc = REXML::Document.new( xml.body ) # put the xml in a variable.
    
    # loop through the <item> tags in the document...
    doc.elements.each("rss/channel/item") do |element|
      item = Item.new
      item.title = element.elements[ "title" ].text
      item.description = element.elements[ "description" ].text
      item.url = element.elements[ "link" ].text
      item.clean_description
      item.tags = []
      element.elements.each("category") do |subelement|
        tag = Tag.new
        tag.name = subelement.text
        tag.url = subelement.attributes[ "domain" ]
        item.tags.push( tag )
      end  
      
      items.push( item )
    end
    return items
  end
  
    
  def index      
    @items = get_items
  end
  
  def update
    @items = get_items
    return render :partial => "slider", :object => @items
  end
  
  def tweet
    Twitter.configure do |config|
      config.consumer_key = "X22BoqxKR8mfLeIeICyaDg"
      config.consumer_secret = "vcrMnZcSobjNzNP5yTx18Kem67R82jJFhalf4Cjf4"
      config.oauth_token = "31685427-PUPg3mc7eY1rCCFVXt1XPXQBCpD9rtpikQTWgIZeY"
      config.oauth_token_secret = "GcOzEaHO5uoeAoXXX45sszhqUJ3UDx3jdsrYi0qFw4"
    end
    Twitter.update("I'm tweeting with @gem!")
    return
  end
     
  
end
