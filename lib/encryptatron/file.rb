require 'json'
require 'yaml'
require 'openssl'
require 'base64'
require 'deep_merge'

module Encryptatron
  class FileHandler
    attr_accessor :file, :iv_file, :enc_file, :data

    def initialize(file)
      self.file = file
    end

    def file=(file)
      @file = file
      self.iv_file = "#{file}.iv"
      self.enc_file = "#{file}.enc"
    end

    def load(key)
      self.data =  File.exist?(file) ? load_unencrypted : {}
      self.data.deep_merge!(load_encrypted(key)) if File.exist?(enc_file) && File.exist?(iv_file)
    end

    def load_unencrypted
      self.data = YAML.load_file(file) if File.exist?(file)
    end

    def load_encrypted(encodedKey)
      key = Base64.decode64(encodedKey)
      decipher = OpenSSL::Cipher::AES.new(256, :CBC)
      decipher.decrypt
      decipher.iv = File.read(iv_file)
      decipher.key = key
      encrypted = File.read(enc_file)

      plain = decipher.update(encrypted) + decipher.final

      self.data = JSON.parse(plain)
    end

    def encrypt!(encodedKey = nil)
      cipher = OpenSSL::Cipher::AES.new(256, :CBC)
      cipher.encrypt
      key = encodedKey.nil? ? cipher.random_key : Base64.decode64(encodedKey)
      cipher.key = key
      iv = cipher.random_iv

      encrypted = cipher.update(JSON.generate(data)) + cipher.final

      File.write(enc_file, encrypted)
      File.write(iv_file, iv)
      Base64.encode64(key)
    end
  end
end
