class AddFloorNumberToproperties < ActiveRecord::Migration[8.0]
  def change
    add_column :properties,:floor_number, :integer
  end
end
