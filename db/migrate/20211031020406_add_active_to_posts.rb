class AddActiveToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :active, :boolean, default: false
  end
end
