class Importer < ActiveRecord::Base

  attr_accessible :source_id, :external_id

  def raw_data
    @raw_data
  end

  def raw_data=(raw_data)
    @raw_data = raw_data
  end

  def generate_data_from_source_syntax(source = nil)
    raise "no RAW_DATA" if @raw_data.nil?
    source ||= self.source
    self.full_name = derive(source.full_name_string, @raw_data)
    self.organization = derive(source.organization_string, @raw_data)
    self.title = derive(source.title_string, @raw_data)
    self.email = derive(source.email_string, @raw_data)
    self.external_id = derive(source.record_id_string, @raw_data).to_i
  end

private

  def derive(template, raw_data)
    template.gsub(/\{[\S]+?\}/) do |match|
      match.slice! '{'
      match.slice! '}'
      raw_data.send(match.to_sym)
    end
  end
end
