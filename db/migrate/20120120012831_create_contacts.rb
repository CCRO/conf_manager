class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :user
      t.string :phone
      t.string :pin
      t.string :muted
      t.text :description

      t.timestamps
    end
  end
end
