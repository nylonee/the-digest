class AddCategoriesToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :categories, :string
  end
end
