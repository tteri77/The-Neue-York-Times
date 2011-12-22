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

  def index   
    # create the @items instance variable.
    @items = []
    
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
      
        
      
      @items.push( item )
    end

    @string = doc.root
    
  end
  
end
