class MakeActiveConferenceSidUnique < ActiveRecord::Migration
  def up
    add_index :active_conferences, :sid, :unique => true
  end

  def down
  end
end
