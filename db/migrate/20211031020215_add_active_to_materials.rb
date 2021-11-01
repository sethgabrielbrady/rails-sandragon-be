class AddActiveToMaterials < ActiveRecord::Migration[6.0]
  def change
    add_column :materials, :active, :boolean, default: false
  end
end
