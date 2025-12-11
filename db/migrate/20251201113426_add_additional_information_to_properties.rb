class AddAdditionalInformationToProperties < ActiveRecord::Migration[8.0]
  def change
    add_column :properties, :additional_information, :json, null: true, default: { information: "unknown" }
  end
end
