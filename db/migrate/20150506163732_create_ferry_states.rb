class CreateFerryStates < ActiveRecord::Migration
  def change
    create_table :ferrystates do |t|
      t.integer :course
      t.string :destination
      t.datetime :etatime
      t.integer :heading
      t.datetime :lastport_arrival
      t.datetime :lastport_departure
      t.string :lastport_name
      t.string :latitude
      t.string :longitude
      t.integer :mmsinumber
      t.string :name
      t.string :navigationstatus
      t.datetime :positionreceived
      t.integer :speed

      t.timestamps
    end
  end
end
