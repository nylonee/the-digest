class RenameColumnXinTableYtoZ < ActiveRecord::Migration
  def change
    rename_column :sources, :title, :name
  end
end
