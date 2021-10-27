class AddBlurbToMaterials < ActiveRecord::Migration[6.0]
  def change
    add_column :materials, :blurb, :string
  end
end
