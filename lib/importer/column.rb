module Importer
  class Column < ActiveRecord::Base
    attr_accessible :source_id, :target_attr, :template, :name

    belongs_to :source
  end
end
