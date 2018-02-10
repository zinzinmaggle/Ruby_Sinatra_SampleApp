class UserProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :user_profiles do |t|
      t.string :name, null: true
      t.string :phone, null: true
      t.string :ZIPcode, null: true
      t.string :city, null: true
      t.integer :userid, null: false
      t.timestamps null: false
    end
  end
end
