class CreateForecasts < ActiveRecord::Migration
  def change
    create_table :forecasts do |t|
      t.integer :station_id
      t.string :feelslike
      t.string :temp
      t.string :dewpoint
      t.string :wind_speed
      t.string :wind_direction
      t.string :humidity
      t.timestamps
    end
  end
end
