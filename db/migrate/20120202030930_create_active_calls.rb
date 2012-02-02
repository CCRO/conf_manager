class CreateActiveCalls < ActiveRecord::Migration
  def change
    create_table :active_calls do |t|
      t.string :sid
      t.string :to
      t.string :from
      t.string :direction
      t.string :caller_name
      t.boolean :muted
      t.boolean :ended
      t.references :active_conference

      t.timestamps
    end
    add_index :active_calls, :active_conference_id
  end
end
