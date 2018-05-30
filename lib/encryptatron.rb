require 'configatron'
require 'dotenv'
require 'encryptatron/cli'
require 'encryptatron/file'
require 'encryptatron/version'
require 'optparse'
Dotenv.load

module Encryptatron
  def self.load(file)
    file = Encryptatron::FileHandler.new(file)
    file.load(ENV['ENCRYPTATRON_KEY'])
    file.data
  end

  def self.use(file)
    configatron.configure_from_hash(load(file))
  end
end
