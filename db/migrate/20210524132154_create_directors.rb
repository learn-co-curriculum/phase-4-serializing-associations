class CreateDirectors < ActiveRecord::Migration[6.1]
  def change
    create_table :directors do |t|
      t.string :name
      t.string :birthplace
      t.string :sex

      t.timestamps
    end
  end
end
