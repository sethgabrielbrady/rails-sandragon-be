class AddSlugToMaterial < ActiveRecord::Migration[6.0]
  def change
    add_column :materials, :slug, :string
  end
end
