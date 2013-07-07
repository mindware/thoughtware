class RemoveCommentCountFromPosts < ActiveRecord::Migration
  def up	
    remove_column :posts, :comments_count
  end

  def down
    add_column :posts, :comments_count, :integer, :default => 0
  end
end
