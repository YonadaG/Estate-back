class FixImageSchema < ActiveRecord::Migration[8.0]
  def change
    # 1. Rename image_url to url
    rename_column :images, :image_url, :url
    
    # 2. Rename caption to alt_text
    rename_column :images, :caption, :alt_text
    
    # 3. Add uploaded_by foreign key
    add_reference :images, :uploaded_by, foreign_key: { to_table: :users }
    
    # 4. Add is_primary boolean
    add_column :images, :is_primary, :boolean, default: false
    
    # 5. Add unique constraint: only one primary image per property
    add_index :images, [:property_id, :is_primary], unique: true, where: "is_primary = true"
  end
end
