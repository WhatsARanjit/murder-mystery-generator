require 'murder/util/yaml'

module MURDER
  class Character

    include MURDER::Util::Yaml

    def initialize(id, gender, role)
      @id     = id
      @gender = gender
      @role   = role
    end

    def character_hash
      {
        'id'     => @id,
        'name'   => "Player #{@id}",
        'gender' => @gender,
        'role'   => @role,
      }
    end

    def target_file
      "#{Dir.pwd}/characters/player_#{@id}.yaml"
    end

    def write_profile
      write_yaml(character_hash, target_file)
    end
  end
end
