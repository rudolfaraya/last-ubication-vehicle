class CreateJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :jobs do |t|
      t.references :waypoint, null: false, foreign_key: true
      t.boolean :error
      t.string :message

      t.timestamps
    end
  end
end
