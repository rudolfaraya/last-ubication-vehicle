class CreateWaypoints < ActiveRecord::Migration[6.0]
  def change
    create_table :waypoints do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.timestamp :sent_at
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
    add_index(:waypoints, :sent_at)
  end
end
