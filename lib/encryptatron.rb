require 'configatron'
require 'dotenv'
require 'encryptatron/cli'
require 'encryptatron/file'
require 'encryptatron/version'
require 'optparse'
Dotenv.load

module Encryptatron
  def self.load(file)
    Encryptatron::FileHandler.new(file).load(ENV['ENCRYPTATRON_KEY'])
  end

  def self.use(file)
    configatron.configre_from_hash(load(file))
  end
end
