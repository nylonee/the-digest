class AddKeywordToSources < ActiveRecord::Migration
  def change
    add_column :sources, :keyword, :string
  end
end
