require 'murder/util/setopts'
require 'murder/util/yaml'
require 'murder/world'
require 'murder/character'
require 'pry'

module MURDER
  module Action
    module Generate
      class Links

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
          puts "= Generating links for characters in \"#{@world.name}\""
          @characters = @world.mk_character_hash
          make_all_enemies
          # I'm seeing that because it proceeds by choosing
          # the person with the least number of friends or
          # enemies and the order of the list was constant,
          # you actually always gets the same friends and
          # enemies.  Shuffling to produce more randomness.
          @characters.shuffle!
          make_all_friends
          rewrite_profiles
        end

        ['enemies', 'friends'].each do |type|
          define_method "create_#{type}" do |personA, personB|
            # Do nothing if that person already has enough connections
            if @characters[personA][type].length < @world.links[type]
              @characters[personA][type] << personB
              msg  = "#{@characters[personB]['name']} "
              msg += "is #{type} with "
              msg += "#{@characters[personA]['name']}"
              puts msg
            end
            if @characters[personB][type].length < @world.links[type]
              @characters[personB][type] << personA
            end
          end

          define_method "pick_#{type}" do |notme|
            puts "== Finding enemy for user #{notme}"
            order = @characters.sort_by { |id, hash| hash[type].length }
            # Can't be your own enemy or friend.  Don't make
            # duplicates.  Don't be friends with your enemy
            # and vice versa. Also, can't be enemies with someone
            # who is already designated your friend.
            notmeid = order.index { |id,hash| id == notme }
            i = 0
            until
            order[i][0] != notme and
            ! order[notmeid][1]['enemies'].include?(order[i][0]) and
            ! order[notmeid][1]['friends'].include?(order[i][0]) and
            ! order[i][1]['enemies'].include?(order[i][0]) and
            ! order[i][1]['friends'].include?(order[i][0]) do
              i += 1
            end
            order[i][0]
          end

          define_method "make_all_#{type}" do
            @characters
            i = 0
            while i < @world.links[type]
              @characters.each do |id, hash|
                person = send(:"pick_#{type}", id)
                send(:"create_#{type}", id, person)
              end
              i += 1
            end
          end
        end

        def rewrite_profiles
          @characters.each do |id, hash|
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
          end
        end
      end
    end
  end
end

class Hash
  def shuffle
    Hash[self.to_a.sample(self.length)]
  end

  def shuffle!
    self.replace(self.shuffle)
  end
end
