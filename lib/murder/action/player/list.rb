require 'murder/util/setopts'
require 'murder/world'

module MURDER
  module Action
    module Player
      class List

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
          @characters = @world.mk_character_hash
          #raise ArgumentError, 'Please supply 2 arguments' if @argv.length != 2

          list_players
        end

        def list_players
          pattern = "%-6s%-15s%-20s\n"
          printf(pattern,
            'ID',
            'Role',
            'Name'
          )
          puts '='*70
          @characters.each do |id, hash|
            printf(pattern,
              id,
              hash['role'],
              hash['name']
            )
          end
        end
      end
    end
  end
end
