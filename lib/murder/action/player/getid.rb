require 'murder/util/setopts'
require 'murder/world'

module MURDER
  module Action
    module Player
      class Getid

        include MURDER::Util::Setopts

        def initialize(opts, argv, cmd)
          @opts     = opts
          @argv     = argv
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
          raise ArgumentError, 'Please supply 1 argument' if @argv.length != 1

          puts get_id(@argv[0])
        end

        def get_id(name)
          @world.get_id_from_name(name)
        end
      end
    end
  end
end
