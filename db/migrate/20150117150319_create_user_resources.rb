class CreateUserResources < ActiveRecord::Migration
  def change
    create_table :user_resources do |t|
      t.string :resource_url
      t.integer :resource_size
      t.references :user, index: true

      t.timestamps
    end
    add_index :user_resources, [:user_id, :created_at]
  end
end
