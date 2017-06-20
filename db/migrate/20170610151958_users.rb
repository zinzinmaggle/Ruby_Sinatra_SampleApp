class Users < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :password, null: false
      t.timestamps null: false
    end
  end
end
