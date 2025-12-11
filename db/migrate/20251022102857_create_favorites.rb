class CreateFavorites < ActiveRecord::Migration[8.0]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :property, null: false, foreign_key: true

      t.timestamps
    end

    add_index :favorites, [:user_id, :property_id], unique: true
    add_index :favorites, :user_id
    add_index :favorites, :property_id
    
  end
end
