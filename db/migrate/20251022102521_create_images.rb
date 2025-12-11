class CreateImages < ActiveRecord::Migration[8.0]
  def change
    create_table :images do |t|
      t.references :property, null: false, foreign_key: true
      t.string :image_url
      t.string :caption

      t.timestamps
    end
  end
end
