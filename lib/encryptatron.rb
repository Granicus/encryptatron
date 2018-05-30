require 'configatron'
require 'dotenv/load'
require 'encryptatron/cli'
require 'encryptatron/file'
require 'encryptatron/version'

module Encryptatron
  def self.load(file)
    Encryptatron::FileHandler.new(file).load(ENV['ENCRYPTATRON_KEY'])
  end

  def self.use(file)
    configatron.configre_from_hash(self.load(file))
  end
end
