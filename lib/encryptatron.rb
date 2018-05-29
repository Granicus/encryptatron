require 'encryptatron/version'
require 'encryptatron/file'
require 'configatron'
require 'dotenv/load'

module Encryptatron
  def self.load(file)
    Encryptatron::FileHandler.new(file).load(ENV['ENCRYPTATRON_KEY'])
  end

  def self.use(file)
    configatron.configre_from_hash(self.load(file))
  end
end
