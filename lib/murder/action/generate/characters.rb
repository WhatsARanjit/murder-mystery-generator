require 'murder/util/setopts'
require 'murder/world'
require 'murder/character'

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

          # Start with totals
          @players    = @world.total_players
          @roles      = @world.roles
          @mf_array   = create_mf_array(@world.male_players, @world.female_players)
          @role_array = create_role_array
          mk_character_dir

          # Generate a character class for each person
          i = 1
          @mf_array.each do |gender|
            char = MURDER::Character.new(i, gender, pick_role)
            char.write_profile
            puts "Created Player_#{i}"
            i += 1
          end
        end

        # Create characters directory if not there
        def mk_character_dir
          dir = "#{@pwd}/characters"
          unless File.exists?(dir)
            Dir.mkdir dir
          else
            $stderr.puts "#{@pwd}/characters already exists!".red
            exit 1
          end
          puts "== Character directory #{dir}"
        end

        # Put together an array of Ms and Fs
        def create_mf_array(males, females)
          Array.new(males, 'M').concat( Array.new(females, 'F') )  
        end

        # Use given roles and fill in rest with 'player'
        def create_role_array
          roles_num = 0
          @roles.each do |r,count|
            roles_num += count
          end
          add = @players - roles_num
          role_return = Array.new(add, 'player')
          @roles.each do |r,count|
            role_return << Array.new(count, r)
          end
          role_return.flatten
        end

        def pick_role
          rand = rand(@role_array.length)
          role = @role_array[rand]
          @role_array.delete_at(rand)
          role
        end
      end
    end
  end
end
