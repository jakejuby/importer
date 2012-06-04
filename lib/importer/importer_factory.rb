module Importer
  class ImporterFactory < ActiveRecord::Base

    def ImporterFactory.connect(source)
      @@source = source
      establish_connection(source.source_configuration)
      self.table_name = source.table_name
    end

    def ImporterFactory.disconnect
      remove_connection
      establish_connection(configurations[Rails.env])
      @@source = nil
    end

    def ImporterFactory.batch_importers(num_per_page = nil, page = nil)
      grab_from_remote("#{@@source.query}" + add_paging(num_per_page, page))
    end


    #TODO: More robust, doing our best here
    def ImporterFactory.batch_with_query(query, num_per_page = nil, page = nil)
      #ridonculous one liner that compares every column with 
      #all the different querys in the query string
      #it is pretty intense -- double split map
      sql_string = generate_sql("(#{@@source.search_columns.map { |column| query.split.map { |query| " #{column} LIKE '%#{query}%'"}.join(" OR") }.join(" OR")})") + add_paging(num_per_page, page)

      grab_from_remote(sql_string)
    end

    def ImporterFactory.load_importers_by_id(external_ids, num_per_page = nil, page = nil)
      
      sql_string = generate_sql("(#{external_ids.map { |id| "#{id_field} = #{id}" }.join(" OR ")})") + add_paging(num_per_page, page)
      grab_from_remote(sql_string)
    end

    def ImporterFactory.count(query = nil)
      if query.nil? or query.blank?
        sql_string = @@source.query.gsub(/^SELECT(.*)FROM/, 'SELECT COUNT(*) FROM')
      else
        sql_string = generate_sql("(#{@@source.search_columns.map { |column| query.split.map { |query| " #{column} LIKE '%#{query}%'"}.join(" OR") }.join(" OR")})").gsub(/^SELECT(.*)FROM/, 'SELECT COUNT(*) FROM')
      end
      c = ImporterFactory.connection.execute(sql_string)
      # execute returns a mysql2 result object, the count query returns a single element array within another array
      c.first.first
    end

    #synchronize the importer with the remote data
    def ImporterFactory.sync_importer(importer)
      connect(importer.source)
      sql_string = generate_sql("#{id_field} = #{importer.external_id}")
      #OPTIMIZE_ME - in the case we need to optimize this can be optimized.
      importer = grab_from_remote(sql_string).first
      importer.save
    end

    def ImporterFactory.save_all(importers)
      importers.each { |importer| importer.save }
    end

  private

    def initialize
      raise "ImporterFactory is a pure abstract class"
    end

    def ImporterFactory.grab_from_remote(sql)
      answer = []
      find_by_sql(sql).each do |data|
        #this line will create an object of type **user_defined**
        answer << Object.const_get(@@source.target.capitalize).new(construct(data))
      end
      answer
    end

    def ImporterFactory.id_field
      @@source.id_field
    end

    def ImporterFactory.generate_sql(where)
      sql_string = "#{@@source.query}"
      if sql_string.include?('WHERE') or sql_string.include?('where')
        sql_string += " AND "
      else
        sql_string += " WHERE "
      end
      sql_string += where
    end

    def ImporterFactory.add_paging(num_per_page, page)
      return "" if num_per_page.nil? or page.nil?
      offset = (page - 1) * num_per_page
      " LIMIT #{num_per_page} OFFSET #{offset}"
    end


    def ImporterFactory.construct(raw_data)
      attr_hash = {}
      @@source.columns.each do |column|
        attr_hash[column.target_attr.to_sym] = derive(column.template, raw_data)
      end
      attr_hash
    end

    def ImporterFactory.derive(template, raw_data)
      template.gsub(/\{[\S]+?\}/) do |match|
        match.slice! '{'
        match.slice! '}'
        raw_data.send(match.to_sym)
      end
    end
  end
end
