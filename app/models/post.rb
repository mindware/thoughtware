# coding: utf-8
class Post < ActiveRecord::Base

  acts_as_commentable
  acts_as_votable

 #Note that order of invoking filters is important, i.e. you want html_escape as first and link amongst last, so that it doesn't transform youtube URL to plain link.
  auto_html_for :url do
    # html_escape     # we are getting double escaped after link_to when this fails
    image
    youtube(:width => 1024, :height => 600)
    vimeo(:width => 1024, :height => 600)
    metacafe(:width => 1024, :height => 600)
    google_video(:width => 1024, :height => 600)
    google_map
    dailymotion
    simple_format
    jplayer(:title => "Test")
  end 

  #Note that order of invoking filters is important, i.e. you want html_escape as first and link amongst last, so that it doesn't transform youtube URL to plain link.
  auto_html_for :description do    
    html_escape
    image
    vimeo(:width => 1024, :height => 600)
    metacafe(:width => 1024, :height => 600)
    google_video(:width => 1024, :height => 600)
    google_map
    dailymotion
    # youtube(:width => 400, :height => 250) # use this for comments
    youtube(:width => 400, :height => 200)    
    link :target => "_blank", :rel => "nofollow"
    simple_format
    jplayer
  end

  # belongs_to user
  # has_many :editors, :through => :commits

  # Attr_acccesible protects against mass assignment. Only add things that the user
  # can modify via mass assignment in a form here.
  # Note: We're dropping support for thumbnail_url, to protect users from remote malicious 
  # content and any potential trolling. Auto-thumbnails are enabled.
  attr_accessible  :description, :title, :url # :thumbnail_url

  # :auto_embed, :comments_count, :comments_last_author, :last_viewed_date, :link_directly, :manual_embed, :status, :thumbnail_code, :user_id, :views

  validates_format_of :url, 
                      :allow_nil => true,
                      :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix,
                      :message => 'appears to have an invalid format.',
                      :if => :url? # same as:allow_nil => true

  after_create :setup # Here we do general setup. Jobs can only be created after the record is persisted.
  # after_save :setup # Here we do general setup. Jobs can only be created after the record is persisted.


  # auto_html_for :auto_embed do
  #   html_escape
  #   image
  #   youtube :width => 400, :height => 250
  #   link :target => "_blank", :rel => "nofollow"
  #   simple_format
  # end  

  # Get the embed code from a post
  def get_embed
  		return self.manual_embed if self.manual_embed.length > 0
  		return self.thumbnail_code if self.thumbnail_code.length > 0
  		return false
  end

  # Check if we can get an embed code for this url
  # returns true | false
  def get_embed?
  		return false | self.get_embed
  end  

  # generate the embed code for this post
  def generate_code
  		if !self.manual_embed.nil?
  		end
  end

  def youtube?
  		if !self.auto_embed.nil?
  			return true if !self.auto_embed.match(/youtube.com/).nil? and self.auto_embed.length > 0
  		end
  		if !self.manual_embed.nil?
  			return true if !self.manual_embed.match(/youtube.com/).nil? and self.manual_embed.length > 0
  		end
  		if !self.url.nil?
  			return true if !self.url.match(/youtube.com/).nil? and self.url.length > 0
  		end
  		return false 
  end

  def youtube_image?
  		if !self.thumbnail_url.nil?
  			return true if !self.thumbnail_url.match(/youtube.com/).nil? and self.thumbnail_url.length > 0
  			return true if !self.thumbnail_url.match(/ytimg.com/).nil? and self.thumbnail_url.length > 0
  		end
  		return false 
  end


 def setup
    # Do any value checks before processing
    self.thumbnail_url = ""	  # reset the thumbnail in case url changed.
    # Downgrade any https vimeo urls to http. The Vimeo gem does some type of redirection
    # when we use https, which makes delayed_job halt the process (because it blocks rediction)
    if self.url.include? "vimeo.com" and self.url.include? "https://"
        self.url = self.url.gsub("https://", "http://")
        # Save the changes  
    end

    # Delayed jobs:
    if url.to_s.length > 0
          # Start processing and queing:    
          # Jobs that we don't need to delay:
          get_domain_from_uri           # worth doing it each time in case url was updated. domain is set to nil if no url

          # Delayed Jobs:
          delay.get_embed_code           
          delay.request_data_from_url   # Get title and other meta-data from the URL
          # delay.resetme  unless url.to_s == "" and !title.to_s == "" # Get title and other meta-data from the URL
          # Old:
          # get_domain_from_url  # we now do this as a delayed task, as not to slow down the server
          # generate thumbnail code
          # generate embed code
    end
    self.save # Save the changes  

 end


  def resetme 
    self.title = "reset" 
  end

 def previous_post
    self.class.first(:conditions => ["id < ?", id], :order => "id desc")
 end

 def next_post
    self.class.first(:conditions => ["id > ?", id], :order => "id asc")
 end

 def query_title(long=false)
    max_length = 100
    if title.to_s.length > 0 
        return title[0..(max_length)] + "..."  if title.length >= (max_length) and !long
        return title
    elsif url.to_s.length > 0
        return url[0..(max_length)] + "..." if url.length >= (max_length) and !long
        return url
    else
        return "Untitled Post"
    end
 end


 # This was to be used to give support to 
 # custom thumbnails, but it wasn't fully implemented,
 # because of a deciscion to drop remote image embedding 
 # from unknown sites in order to make it more secure for our users 
 # def query_image(long=false)
 #    # we have a custom thumb provided by the user
 #    if self.thumbnail.to_s.length > 0
 #        return self.thumbnail 
 #    elsif self.thumbnail_auto.to_s.length > 0 
 #        return self.thumbnail_auto
 #    else
 #        nil
 #    end
 # end 

# From here on, private methods, only available from this class
# private

# This method gets the domain from the URI provided
# it doesn't actually do a request, just parses the URI and gets the domain.
def get_domain_from_uri
    # Next we extract the domain from the URL if present
    if(attribute_present?("url"))
            if(self.url.to_s != "")
                    # begin
                      self.domain = get_host_without_www(self.url)
                    # rescue
                      # self.domain = nil
                    # end
            end
    end
    #                         require 'uri'
    #                         address = URI.parse(url).host
    #                         match = address.to_s.match(/^(www\.)/)
    #                         if(!match.nil?)
    #                                  self.domain = address.gsub(match[0], "")
    #                         else
    #                                  self.domain = address
    #                         end
    #                 rescue
    #                         self.domain = nil # Parsing failed
    #                 end
    #         #end
    #         else
    #                         self.domain = nil
    #         end
    # else
    #                 self.domain = nil
    # end
  end


# Only parses twice if url doesn't start with a scheme
def get_host_without_www(url)
    require 'uri'
    uri = URI.parse(url)
    uri = URI.parse("http://#{url}") if uri.scheme.nil?
    host = uri.host.downcase
    host.start_with?('www.') ? host[4..-1] : host
end

# This method does a HTTP request to the specified URL and 
# extracts the title - called as a delayed job
def request_data_from_url
    return nil if url.to_s == ""
    # Grab Title
    if title.to_s == "" # If the title is not empty, we do not grab a title, because we do not over-write titles.

         # begin # commented out at the moment, we want the jobs to report failures
            require 'pismo'    
            doc = Pismo::Document.new(url)        
            if doc.title.to_s.strip != ""
                doc.title 
                self.title = doc.title
            end
         # rescue Exception => e
               # do nothing
    	   # puts "The error is: #{e.inspect}" 
         # end
    end
    # Grab Thumbnail
    if(self.domain.to_s.include? "youtube" or self.domain.to_s.include? "youtu.be") # if this is a youtube link
      # the following if has been disabled, as we have disabled custom thumbnails.
      # if thumbnail_url.to_s == "" # if no thumbnail has been submitted or its broken
              require 'youtube_it'
              client  = YouTubeIt::Client.new
              video   = client.video_by(self.url)
              thumb   = "" # the thumbnail we've found & chosen
              video.thumbnails.each do |t|      
                  # Always prefer High-Quality and Max Width * Height                          
                  if t.url.include? "sddefault" 
                      thumb = t.url 
                      break # break out of hte loop
                  # If not, grab the High Quality with smaller Width * Height
                  elsif t.url.include? "hqdefault" and !thumb.include? "sddefault"
                      thumb = t.url    
                  # If not, grab the Medium Quality            
                  elsif t.url.include? "mqdefault" and !thumb.include? "sddefault" and !thumb.include? "hqdefault"
                      thumb = t.url                            
                  # Grab what we find, unless we've hit a decent quality image already
                  elsif !thumb.include? "hqdefault" and !thumb.include? "mqdefault" and !thumb.include? "sddefault"
                      # But if we don't yet have a good thumbnail stored, grab whatever we can find.
                      thumb = t.url 
                  end
              end
              self.thumbnail_url = thumb unless thumb.to_s.length == 0
      # end
    elsif(self.domain.to_s.include? "vimeo.com")
            # Downgrade any https vimeo urls to http. The Vimeo gem does some type of redirection
            # when we use https, which makes delayed_job halt the process (because it blocks rediction)
            if self.url.include? "https://"
                self.url.gsub("https://", "http://")
                # Save the changes
                self.save      
            end
            # only parses twice if the URL doesn't begin with a scheme
            # vimeo urls look as follows in 2013: http://vimeo.com/62950365
            # we want to extract the id, which is everything after vimeo.com
            # in the following code we handle uris that are submitted without the scheme (http)
            require 'uri'
            uri = URI.parse(self.url.to_s)
            uri = URI.parse("http://#{self.url.to_s}") if uri.scheme.nil?
            vimeo_id = uri.path.to_s.gsub("/", "")

            puts "Vimeo_id: #{vimeo_id}"
            require 'vimeo'            
            video = Vimeo::Simple::Video.info(vimeo_id)
            self.thumbnail_url = video[0]["thumbnail_large"] #unless video.nil?            
            puts "vimeo video: #{video}"
    #elseif
    else
      #Let's process other file-types
      if( self.url.end_with? ".jpg" or self.url.end_with? ".png" or self.url.end_with? ".gif" )
        begin
          # require 'digest/md5'
          # require "open-uri"
          # filename = Digest::MD5.hexdigest(self.url)
          # open(filename) {|f|
          #    File.open("public/dl/#{filename}","wb") do |file|
          #      file.puts f.read
          #    end                          
          # }  
          self.thumbnail_url = self.url
          self.save        
        rescue Exception => e
          puts "Error ocurred #{e.inspect}"
        end
      end

    end

    # if(self.thumbnail_url.to_s == "" and self.url.to_s.length > 0)
    #     self.thumbnail_url = "http://api.webthumbnail.org?width=512&height=512&format=png&browser=firefox&url=#{self.url}"
    # end
    self.save # we have to save here, because this is a delayed job and will ocurr at a future time after setup()
end

end
