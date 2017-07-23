class ApplicationItems < ActiveRecord::Migration[5.1]
  def change
    create_table :application_items do |t|
  		t.string :appname
      t.string :appframework
      t.integer :userid
      t.string :category
      t.timestamps null: false
  	end
  end
end
