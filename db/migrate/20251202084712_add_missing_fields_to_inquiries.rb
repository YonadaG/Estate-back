class AddMissingFieldsToInquiries < ActiveRecord::Migration[8.0]
  def change
   add_column :inquiries, :contact_preference, :string, default: 'email'
    add_column :inquiries, :response_message, :text
    add_column :inquiries, :responded_at, :datetime
    add_reference :inquiries, :responded_by, foreign_key: { to_table: :users }

    # Add unique index to prevent duplicate inquiries
    add_index :inquiries, [:user_id, :property_id], unique: true
  end
end
