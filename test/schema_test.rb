require 'minitest/autorun'
require 'nokogiri'
require_relative '../lib/ebics'

class SchemaTest < Minitest::Test
  def setup
    @bank = EBICS::Bank.new
    @bank.host_id = 'EBIXH'

    @user = EBICS::User.new do |key|
      path = 'keys/' + key.type + '.pem'
      if File.exists?(path)
        key.rsa = OpenSSL::PKey::RSA.new(File.read(path))
      else
        key.rsa = OpenSSL::PKey::RSA.new(2048)
        File.open(path, 'w') do |file|
          file.write key.rsa.to_pem
        end
      end

      key.created_at = File.mtime(path)
    end

    @user.partner_id = 'EBIXP'
    @user.member_id = 'EBIXU'

    @hia = EBICS::HIA.new
    @hia.user = @user
    @hia.bank = @bank

    @ini = EBICS::INI.new
    @ini.user = @user
    @ini.bank = @bank

  end

   def test_ini_schema
    doc = Nokogiri::XML(@ini.render.to_s.tap {|ini| puts ini })


    Dir.chdir('xsd') do
      xsd = Nokogiri::XML::Schema(File.read('ebics_H004.xsd'))
      errors = []
      xsd.validate(doc).each do |error|
        errors << error
      end
      assert_empty errors, errors.join("\n")
    end
   end

  def test_ini_order_data_schema
    doc = Nokogiri::XML(@ini.raw_order_data('INI_order_data.xml').to_s.tap {|ini| puts ini })


    Dir.chdir('xsd') do
      xsd = Nokogiri::XML::Schema(File.read('ebics_signature.xsd'))
      errors = []
      xsd.validate(doc).each do |error|
        errors << error
      end
      assert_empty errors, errors.join("\n")
    end
  end


  def test_hia_schema
    doc = Nokogiri::XML(@hia.render.to_s.tap {|hia| puts hia })


    Dir.chdir('xsd') do
      xsd = Nokogiri::XML::Schema(File.read('ebics_H004.xsd'))
      errors = []
      xsd.validate(doc).each do |error|
        errors << error
      end
      assert_empty errors, errors.join("\n")
    end
  end

  def test_hia_order_data_schema
    doc = Nokogiri::XML(@hia.raw_order_data('HIA_order_data.xml').to_s.tap {|hia| puts hia })


    Dir.chdir('xsd') do
      xsd = Nokogiri::XML::Schema(File.read('ebics_H004.xsd'))
      errors = []
      xsd.validate(doc).each do |error|
        errors << error
      end
      assert_empty errors, errors.join("\n")
    end
  end
end

