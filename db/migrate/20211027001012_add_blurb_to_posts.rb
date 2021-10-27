class AddBlurbToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :blurb, :string
  end
end
