require "mscrmrails/version"
require "savon"
require "crack"

module Mscrmrails
  module_function

  class Configuration
    attr_accessor :server, :port, :server_path, :domain, :username, :password, :soap_header, :guid

    def initialize
      self.server = nil
      self.port = '5555'
      self.soap_header = '<soap:Header></soap:Header>'
      self.server_path = 'mscrmservices/2006/crmservice.asmx'
      self.domain = nil
      self.username = nil
      self.password = nil
      self.guid = nil
    end
  end
  
  class CRM

    def initialize
      HTTPI::Adapter.use = :net_http

      @@client = Savon::Client.new do |wsdl, http|
        wsdl.document = "http://#{Mscrmrails.config.server}:#{Mscrmrails.config.port}/#{Mscrmrails.config.server_path}" + '?wsdl'
        wsdl.element_form_default = :qualified
        http.auth.ntlm(Mscrmrails.config.username, Mscrmrails.config.domain, Mscrmrails.config.password)
        http.auth.ssl.verify_mode = :none
      end

      @@client.config.env_namespace = :soap
    end

    def build_fetchxml entity, options = {}
      limit = options[:limit] ? options[:limit] : 200
      xml = "<fetch mapping='logical' page='1' count='#{limit.to_s}'><entity name='#{entity}'>"

      options[:fields].each do |attribute|
        xml += "<attribute name='" + attribute + "'/>"
      end

      if options[:conditions]
        options[:conditions].each do |condition, op|
          xml += "<filter type='" + condition + "'>"
          op.each do |value|
            o = value[2] ? value[2] : 'eq'
            xml += "<condition attribute='" + value[0] + "' operator='" + o + "' value='" + value[1] + "' />"
          end
          xml += "</filter>"
        end
      end
      xml += "</entity></fetch>"
      return xml
    end

    def fetch entityname, options = {}
      result = @@client.request :fetch do |soap|
        soap.header = ''

        body = Hash.new
        body["fetchXml"] = build_fetchxml entityname, options
        soap.body = body
      end
      #return result
      results = Crack::XML.parse(result.body[:fetch_result])["resultset"]["result"]
      results.class == Hash ? [results] : results
    end

    def create entityname, options = {}
      result = @@client.request :create , type: entityname do |soap|
        xml = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><entity xmlns='http://schemas.microsoft.com/crm/2006/WebServices'  xsi:type='#{entityname}'>"
        options[:attributes].each do |key,value|
          xml += "<#{key}>#{value}</#{key}>"
        end
        xml += "</entity></soap:Body></soap:Envelope>"
        soap.xml = xml 
      end
      result.body[:create_result]
    end
  end

  def self.configure
    yield(config) if block_given?
  end

  def self.config
    @configuration ||= Configuration.new
  end
end
