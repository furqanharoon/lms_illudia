class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
    	t.string "title" 
    	t.string "genre"
    	t.date "release_date"
    	

      t.timestamps
    end
  end
end
