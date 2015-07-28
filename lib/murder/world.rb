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
  end
end
