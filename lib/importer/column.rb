module Importer
  class Column < ActiveRecord::Base
    attr_accessible :source_id, :target_attr, :template

    belongs_to :source
  end
end
