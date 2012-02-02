class AddFriendlyNameToActiveConference < ActiveRecord::Migration
  def change
      add_column :active_conferences, :friendly_name, :string
  end
end
