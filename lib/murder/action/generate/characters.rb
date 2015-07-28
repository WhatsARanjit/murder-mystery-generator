require 'murder/util/setopts'
require 'murder/world'
require 'pry'

module MURDER
  module Action
    module Generate
      class Characters

        include MURDER::Util::Setopts

        def initialize(opts, argv, cmd)
          @opts = opts
          @argv = argv
          setopts(opts, {
            :config => :self,
            :trace  => :self,
          })

          # Setup defaults
          @pwd      = Dir.pwd
          @config ||= "#{@pwd}/game.yaml"
          @world    = MURDER::World.new(@config)

        end

        def call
          puts "= Generating characters for \"#{@world.name}\""
          character_dir
        end

        # Create characters directory if not there
        def character_dir
          @dir = "#{@pwd}/characters"
          Dir.mkdir @dir unless File.exists?(@dir)
          puts "== Created #{@dir}"
        end
      end
    end
  end
end
