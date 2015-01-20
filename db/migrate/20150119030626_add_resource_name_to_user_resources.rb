class AddResourceNameToUserResources < ActiveRecord::Migration
  def change
    add_column :user_resources, :resource_name, :string
  end
end
