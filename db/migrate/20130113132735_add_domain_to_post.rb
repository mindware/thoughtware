class AddDomainToPost < ActiveRecord::Migration
  def change
    add_column :posts, :domain, :string
  end
end
