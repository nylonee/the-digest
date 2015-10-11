class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.datetime :date_time
      t.string :summary
      t.string :author
      t.string :image
      t.string :link

      t.timestamps null: false
    end
  end
end
