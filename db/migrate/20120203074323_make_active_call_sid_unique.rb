class MakeActiveCallSidUnique < ActiveRecord::Migration
  def up
    add_index :active_calls, :sid, :unique => true
  end

  def down
  end
end
