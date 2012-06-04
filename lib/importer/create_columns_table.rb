class CreateColumns < ActiveRecord::Migration
  def self.up
    create_table :columns do |t|
      t.string :source_id
      t.string :target_attr
      t.string :template
      t.timestamps
    end
  end

  def self.down
    drop_table :columns
  end
end
