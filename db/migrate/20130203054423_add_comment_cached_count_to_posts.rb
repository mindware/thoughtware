class AddCommentCachedCountToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :cached_comments_total, :integer, :default => 0
    add_index  :posts, :cached_comments_total
  end

  def self.down
    remove_column :posts, :cached_comments_total
  end
end
