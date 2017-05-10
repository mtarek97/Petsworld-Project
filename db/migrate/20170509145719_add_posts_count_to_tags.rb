class AddPostsCountToTags < ActiveRecord::Migration[5.0]
  def change
	add_column :tags, :posts_count, :integer, :null => false, :default => 0
  end
end
