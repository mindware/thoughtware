class AddIsEmbeddableToPost < ActiveRecord::Migration
  def change
    add_column :posts, :is_embeddable, :boolean, :default => true
  end
end
