class AddBedsToPerson < ActiveRecord::Migration
  def change
    add_column :people, :bed, :integer
  end
end
