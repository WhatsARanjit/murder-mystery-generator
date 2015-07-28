require 'yaml'

module MURDER
  module Util
    module Yaml

      private

      def yaml(file_path)
        YAML.load_file(file_path)
        rescue Exception => err
          puts "YAML invalid: #{file_path}"
          raise "#{err}"
      end

      def write_yaml(hash, file)
        File.open(file, 'w') { |file| file.write(hash.to_yaml) }
      end
    end
  end
end
