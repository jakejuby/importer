module Importer
  class Source < ActiveRecord::Base

    attr_accessible :adapter, :host, :username, :password, :database, :name, :table_name, :id_field, :query

    has_many :columns

    def source_configuration
      {
        :adapter  => self.adapter,
        :host     => self.host,
        :username => self.username,
        :password => self.password,
        :database => self.database
      }
    end

    def search_columns
      self.columns.map { |column| column.name }
    end

    def query
      self[:query].nil? or self[:query].blank? ? "SELECT * FROM self.table_name" : self[:query]
    end
  end
end
