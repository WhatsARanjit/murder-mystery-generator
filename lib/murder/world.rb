require 'murder/util/yaml'

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
  end
end
