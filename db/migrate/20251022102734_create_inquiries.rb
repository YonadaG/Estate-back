class CreateInquiries < ActiveRecord::Migration[8.0]
  def change
    create_table :inquiries do |t|
      t.references :user, null: false, foreign_key: true
      t.references :property, null: false, foreign_key: true
      t.text :message
      t.string :status

      t.timestamps
    end
  end
end
