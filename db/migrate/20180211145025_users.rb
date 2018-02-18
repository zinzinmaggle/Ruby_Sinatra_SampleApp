class Users < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :password, null: false
      t.string :session_hashed, null:false
      t.string :series_identifier, null:false
      t.timestamps null: false
    end
  end
end
