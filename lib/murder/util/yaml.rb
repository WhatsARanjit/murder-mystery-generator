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
    end
  end
end
