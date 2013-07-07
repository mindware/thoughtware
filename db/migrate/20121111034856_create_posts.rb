class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :url
      t.string :title
      t.text :description
      t.integer :user_id
      t.boolean :status
      t.string :thumbnail_url
      t.text :thumbnail_code
      t.text :auto_embed
      t.text :manual_embed
      t.integer :comments_count
      t.integer :comments_last_author
      t.integer :views
      t.date :last_viewed_date
      t.integer :link_directly

      t.timestamps
    end
  end
end
