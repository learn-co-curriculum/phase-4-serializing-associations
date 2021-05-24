class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.string :author
      t.string :date
      t.string :url
      t.integer :movie_id

      t.timestamps
    end
  end
end
