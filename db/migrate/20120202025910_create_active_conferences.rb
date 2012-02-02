class CreateActiveConferences < ActiveRecord::Migration
  def change
    create_table :active_conferences do |t|
      t.string :sid

      t.timestamps
    end
  end
end
