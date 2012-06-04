class CreateSources < ActiveRecord::Migration
  def self.up
    create_table :sources do |t|
      t.string :adapter
      t.string :host
      t.string :username
      t.string :password
      t.string :database
      t.string :name
      t.string :table_name
      t.string :id_field
      t.string :query
      t.timestamps
    end
  end

  def self.down
    drop_table :sources
  end
end
