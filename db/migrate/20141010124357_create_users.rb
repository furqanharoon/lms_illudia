class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string "username"
    	t.string "login"
    	t.string "email"
    	t.string "password"
    	

      t.timestamps
    end
  end
end