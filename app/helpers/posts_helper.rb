module PostsHelper
	def tag_links(tags)
		tags.split(",").map{|tag| link_to tag.strip, tag_path(tag.strip) }.join(", ") 
	end
def taggle_like_button(post, user)
	
if user.likes?(post)

 link_to "unlike", like_post_path(post)
else
	link_to "like", like_post_path(post)
end
	end

	def tag_cloud(tags, classes)
		max = tags.sort_by(&:count).last
		tags.each do |tag|
			index = tag.count.to_f / max.count * (classes.size-1)
			yield(tag, classes[index.round])
		end
	end
end
