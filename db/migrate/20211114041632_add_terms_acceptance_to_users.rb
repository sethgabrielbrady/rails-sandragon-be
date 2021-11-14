class AddTermsAcceptanceToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :terms_of_service, :boolean, default: false
  end
end
