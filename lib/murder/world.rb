require 'murder/util/yaml'
require 'pry'

module MURDER
  class World

    include MURDER::Util::Yaml

    def initialize(config)
      @world = yaml(config)

      # Define getters for all keys
      @world.each do |k,v|
        self.class.send(:define_method, k) do
          @world[k]
        end
      end
    end

    def male_players
      self.players['m']
    end

    def female_players
      self.players['f']
    end

    def total_players
      self.players['f'] + self.players['m']
    end

    def friends
      self.links['friends']
    end

    def enemies
      self.links['enemies']
    end

    def list_profiles
      Dir["#{Dir.pwd}/characters/*"].shuffle
    end 

    def mk_character_hash
      character_hash = {}
      list_profiles.each do |profile|
        profile_hash = yaml(profile)
        id = profile_hash['id']
        character_hash[id] = profile_hash
      end
      character_hash
    end

    def role_lookup(role)
      characters = mk_character_hash
      m = characters.select { |id, hash| hash['role'] == role }
      m.keys
    end
  end
end
