require 'murder/util/setopts'
require 'murder/util/yaml'
require 'murder/world'
require 'murder/character'

module MURDER
  module Action
    module Player
      class List

        include MURDER::Util::Setopts
        include MURDER::Util::Yaml

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
          raise ArgumentError, 'Please supply 2 arguments' if @argv.length != 2

          puts "Changed '#{@argv[0]}' to '#{@argv[1]}'." if (
            id = old_name_id( @argv[0])
            update_name( id, @argv[1] )
            char = MURDER::Character.new(
              id,
              @characters[id]['gender'],
              @characters[id]['role'],
              @characters[id]['name'],
              @characters[id]['costume'],
              @characters[id]['enemies'],
              @characters[id]['friends'],
              @characters[id]['public']
            )
            char.write_profile
          )
        end

        def old_name_id(oldname)
          oldid = @characters.select { |id, hash| hash['name'] == oldname }
          begin
            oldid.keys.first
          rescue ArgumentError
            $stderr.puts "Player named '#{@argv[0]}' does not exist!".red
          end
        end

        def update_name(oldid, newname)
          @characters[oldid]['name'] = newname
        end
      end
    end
  end
end
