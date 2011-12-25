require 'net/http'
require 'rexml/document'

class Feed
  attr_accessor :url
  attr_accessor :name
  
  def initialize( name, url )
    @url = url
    @name = name
  end
  
end
  
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
  
  def create_feeds
    
    feeds = []
    feeds.push( Feed.new( 'front page', 'http://feeds.nytimes.com/nyt/rss/HomePage' ) )
    feeds.push( Feed.new( 'science', 'http://feeds.nytimes.com/nyt/rss/Science' ) )
    feeds.push( Feed.new( 'space', 'http://feeds.nytimes.com/nyt/rss/Space' ) )
    feeds.push( Feed.new( 'business', 'http://feeds.nytimes.com/nyt/rss/Business' ) )
    feeds.push( Feed.new( 'arts', 'http://feeds.nytimes.com/nyt/rss/Arts' ) )
    
    return feeds
    
  end
  
  def get_items( url )
    # create the @items instance variable.
    items = []
    
    # go and get the xml.
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
    url = ""
    @feeds = create_feeds
    @feeds.each do |feed|
      url = feed.url if feed.name == "front page"
    end
    @items = get_items( url )
  end
  
  def update
    url = "http://feeds.nytimes.com/nyt/rss/HomePage"
    requested_feed = params[ :feed ]
    @feeds = create_feeds
    @feeds.each do |feed|
      url = feed.url if requested_feed == feed.name
    end
    @items = get_items( url )
    return render :partial => "slider", :object => @items
  end
     


end
