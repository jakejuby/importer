require 'rubygems'
require 'active_record'

class Source < ActiveRecord::Base

  attr_accessible :adapter, :host, :username, :password, :database, :name, :table_name

  def source_configuration
    {
      :adapter  => self.adapter,
      :host     => self.host,
      :username => self.username,
      :password => self.password,
      :database => self.database
    }
  end
end
