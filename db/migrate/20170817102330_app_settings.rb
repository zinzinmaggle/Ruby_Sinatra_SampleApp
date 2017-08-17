class AppSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :app_settings do |t|
      t.string :appnotifications, null: true
      t.integer :userid, null: false
      t.timestamps null: false
    end
  end
end
