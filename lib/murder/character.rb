require 'murder/util/yaml'

module MURDER
  class Character

    include MURDER::Util::Yaml

    def initialize(
      id,
      gender,
      role,
      name    = "Player #{@id}",
      costume = '',
      enemies = [],
      friends = [],
      info    = ''
    )
      @id      = id
      @gender  = gender
      @role    = role
      @name    = name
      @costume = costume
      @enemies = enemies
      @friends = friends
      @public  = info
    end

    def character_hash
      {
        'id'      => @id,
        'name'    => "Player #{@id}",
        'gender'  => @gender,
        'role'    => @role,
        'public'  => @public,
        'costume' => @costume,
        'enemies' => @enemies,
        'friends' => @friends,
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
