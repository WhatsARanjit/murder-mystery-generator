require 'murder/util/setopts'
require 'murder/util/yaml'
require 'pry'

module MURDER
  module Action
    module Generate
      class Characters

        include MURDER::Util::Setopts
        include MURDER::Util::Yaml

        def initialize(opts, argv, cmd)
          @opts = opts
          @argv = argv
          setopts(opts, {
            :config     => :self,
            :trace      => :self
          })

          # Setup defaults
          @config ||= "#{Dir.pwd}/game.yaml"
          @config_hash = yaml(@config)

        end

        def call
          binding.pry
          puts @config_hash['name']
        end
      end
    end
  end
end
