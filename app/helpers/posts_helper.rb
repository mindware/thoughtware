require 'digest/md5'

module PostsHelper

	def image_animation (post, thumb)
		time = Time.now
		key = rand(100).to_s + time.to_s
		key = Digest::MD5.hexdigest(key)
		#link_to (image_tag "icons/GIF-play.png", :id => key, 
		#		:class => 'thumbnail gif'), post_path(post), 
		#		# switchImage params: first image, replacement gif on Click, DOM id 
		#		:onclick => "switchImage('/assets/icons/GIF-play.png', '#{thumb}', '#{key}'); return false;"
		str = %Q{
		 <div style="padding:50px; font-size: 30pt; font-weight: bold; text-align: center;" class="thumbnail gif centered">
				 <div>
				 	GIF
				 </div>
        		<div class="large-12 roundly columns gradient centered" style="font-size: 10pt; padding: 10px; text-align: center;">
            		click to play
        		</div>
		</div>
		}

		return link_to raw(str), post_path(post), :onclick => "openModal('#{view_post_path(post.id)}'); return false;"

	end

	# generate css classes based on the html
	def get_css_classes(output, post)
        # here we contruct the css classes to add to the media
        # we don't add zurb foundation flex-video tags for mp3 embeds
        css_classes = "flex-video widescreen"   unless post.url[-4..-1] == ".mp3"
        css_classes = css_classes + " youtube"  if output.include? "youtube.com"
        css_classes = css_classes + " vimeo"    if output.include? "vimeo.com"
        # Reset classes for images
        css_classes = "image"  if post.url[-4..-1] == ".jpg" or post.url[-4..-1] == ".gif" or post.url[-4..-1] == ".png" or post.url[-5..-1] == ".jpeg"
        return css_classes
    end

end
