class CreateMovies < ActiveRecord::Migration[6.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.integer :year
      t.integer :length
      t.string :description
      t.string :poster_url
      t.string :category
      t.boolean :discount
      t.integer :director_id

      t.timestamps
    end
  end
end
