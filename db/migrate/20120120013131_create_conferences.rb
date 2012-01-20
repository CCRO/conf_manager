class CreateConferences < ActiveRecord::Migration
  def change
    create_table :conferences do |t|
      t.string :confname
      t.string :pin
      t.string :sid
      t.text :description

      t.timestamps
    end
  end
end
