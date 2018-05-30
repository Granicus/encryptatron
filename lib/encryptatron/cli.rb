module Encryptatron
  class CLI
    def self.invoke(args)
      env_key = ENV['ENCRYPTATRON_KEY']
      key = env_key.nil? || env_key.empty? ? nil : env_key

      optparse = OptionParser.new do |opts|
        opts.banner = "Usage: encryptatron [flags] <encrypt|decrypt> <file>"

        opts.on('-k', '--key [base64 encoded key]', 'Specify a base64 encoded encryption key') do |_key|
          key = url
        end

        opts.on('-h', '--help', 'Show help message') do
          puts opts
          exit 1
        end
      end

      params = optparse.parse!(args)
      action = params[0]
      unless params.length == 2 && (action == 'encrypt' || action == 'decrypt')
        puts 'You must specify either encrypt or decrypt and a file'
        puts optparse
        exit 1
      end

      file = Encryptatron::FileHandler.new(params[1])
      if action == 'encrypt'
        file.load_unencrypted
        new_key = file.encrypt!(key)
        puts "Generated new encryption key: #{new_key}" unless key
      elsif action == 'decrypt'
        file.load(key)
        File.write(file.file, YAML.dump(file.data))
      end
    end
  end
end
