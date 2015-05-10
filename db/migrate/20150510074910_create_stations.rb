

class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.float :lat
      t.float :lng
      t.string :pws_id
      t.string :name
      t.integer :forecast_id
      t.timestamps
    end
  end
end
