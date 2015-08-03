require 'murder/util/yaml'
require 'erb'
require 'redcarpet'
require 'pdfkit'

module MURDER
  class Character

    include MURDER::Util::Yaml

    def initialize(
      id,
      gender,
      role,
      name    = "Player #{id}",
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
        'name'    => @name,
        'gender'  => @gender,
        'role'    => @role,
        'public'  => @public,
        'costume' => @costume,
        # Prevent duplicate IDs
        'enemies' => @enemies.uniq,
        'friends' => @friends.uniq,
      }
    end

    def target_file
      "#{Dir.pwd}/characters/player_#{@id}.yaml"
    end

    def write_profile
      write_yaml(character_hash, target_file)
    end

    def write_pdf
      profile_template = File.read('../templates/profile.md.erb')
      renderer         = ERB.new(profile_template)
      md               = renderer.result()
      html             = Redcarpet::Markdown.new(
        Redcarpet::Render::HTML,
        autolink: true,
        tables: true,
        strikethrough: true, 
        enced_code_blocks: true
      ).render(md)
      pdf              = PDFKit.new(html, :page_size => 'Letter')
      #pdf.stylesheets << '/Users/ranjit/Customers/PS/ranjit.css'
      pdf.to_file("#{@name}.pdf")
    end
  end
end
