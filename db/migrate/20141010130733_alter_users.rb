class AlterUsers < ActiveRecord::Migration
  def up
  	add_column("users","admin",:boolean,:after => "password")

  end
  
end
