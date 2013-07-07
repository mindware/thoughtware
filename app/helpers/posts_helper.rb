require 'digest/md5'

module PostsHelper

	def image_animation (post, thumb)
		time = Time.now
		key = rand(100).to_s + time.to_s
		key = Digest::MD5.hexdigest(key)
		link_to (image_tag "icons/GIF-play.png", :id => key, 
				:class => 'thumbnail gif'), post_path(post), 
				# switchImage params: first image, replacement gif on Click, DOM id 
				:onclick => "switchImage('/assets/icons/GIF-play.png', '#{thumb}', '#{key}'); return false;"
		# "hello there"
	end


end
