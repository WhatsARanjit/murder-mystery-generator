require 'murder/util/setopts'
require 'murder/world'
require 'murder/character'

module MURDER
  module Action
    module Player
      class Attr

        include MURDER::Util::Setopts

        def initialize(opts, argv, cmd)
          @opts     = opts
          @argv     = argv
          @id       = @argv[0].to_i
          @attr     = @argv[1]
          @newvalue = @argv[2]
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

          if @argv.length == 1
            puts list_all_attrs(@id)
          elsif @argv.length == 2
            puts list_attr(@id, @attr)
          elsif @argv.length == 3
            set_attr(@id, @attr, @newvalue)
          else
            raise ArgumentError,
              "Usage: murder player attr <id> [<attr>] [<new value>]"
            exit 1
          end
        end

        def list_all_attrs(id)
          require 'json'
          JSON.pretty_generate(@characters[id])
        end

        def list_attr(id, attr)
          @characters[id][attr]
        end

        def read_only_attr
          [
            'id',
            'role',
            'enemies',
            'friends'
          ]
        end

        def set_attr(id, attr, newvalue)
          if read_only_attr.include?(attr)
            $stderr.puts "Attribute '#{attr}' is read-only".red
            exit 1
          end
          chg_msg  = "Changed "
          chg_msg += attr
          chg_msg += " from '"
          chg_msg += @characters[id][attr]
          chg_msg += "' to '"
          chg_msg += newvalue
          chg_msg += "'"
          puts chg_msg if (
            @characters[id][attr] = newvalue
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
