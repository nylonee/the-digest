class RemoveKeywordFromSources < ActiveRecord::Migration
  def change
    remove_column :sources, :keyword, :string
  end
end
