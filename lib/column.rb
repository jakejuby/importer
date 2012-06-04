class Column < ActiveRecord::Base

  attr_accessible :source_id, :target_attr, :template, :name

  attr_accessor :source_id, :target_attr, :template, :name
  
end
