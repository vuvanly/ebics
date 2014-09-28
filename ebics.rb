require 'zlib'
require 'base64'
require 'erb'
require 'openssl'
require 'time'

module EBICS
  class Request
    def render_order_data(name)
      zipped_order_data = Zlib::Deflate.deflate raw_order_data(name)
      Base64.encode64(zipped_order_data)
    end

    def raw_order_data(name)
      ERB.new(File.read('templates/' + name + '.erb')).result(binding)
    end
  end

  class HEV < Request
    attr_accessor :bank

    def render
      ERB.new(File.read('templates/HEV.xml' + '.erb')).result(binding)
    end
  end

  class INI < Request
    attr_accessor :user
    attr_accessor :bank

    def render
      ERB.new(File.read('templates/INI.xml' + '.erb')).result(binding)
    end
  end

  class HIA < Request
    attr_accessor :user
    attr_accessor :bank

    def render
      ERB.new(File.read('templates/HIA.xml' + '.erb')).result(binding)
    end
  end


  class User
    attr_accessor :partner_id
    attr_accessor :member_id
    def initialize(&block)
      @key_initializer = block
      @keys = {}
    end

    def key(type)
      @keys[type.to_sym] || (@keys[type] = initialize_key(type))
    end

    def initialize_key(type)
      key = Key.new(type)
      @key_initializer.call(key)
      return key
    end
  end

  class Bank
    attr_accessor :host_id

  end

  class Key
    attr_accessor :rsa, :type
    attr_writer :created_at

    def initialize(type)
      @type = type
    end

    def public_modulus
      [@rsa.public_key.n.to_s(2)].pack 'm'
    end

    def public_exponent
      [@rsa.public_key.e.to_s(2)].pack 'm'
    end

    def created_at
      @created_at.iso8601(10)
    end
  end
end
