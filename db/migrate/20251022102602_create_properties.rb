 class CreateProperties < ActiveRecord::Migration[8.0]
  def change
    create_table :properties do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null:false
      t.text :description, null:false
      t.decimal :price, null: false
      t.string :location
      t.string :property_type
      t.string :status
      t.integer :bedrooms
      t.integer :bathrooms
      t.float :area

      t.timestamps
    end
  end
end
