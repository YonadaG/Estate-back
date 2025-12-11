class AddUploadedbyToImages < ActiveRecord::Migration[8.0]
  def change
    add_reference :images, :uploaded_by, null: false, foreign_key: { to_table: :users }
  end
end
