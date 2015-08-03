require 'murder/cli'
require 'murder/action/generate'
require 'cri'

module MURDER::CLI
  module Generate
    def self.command
      @cmd ||= Cri::Command.define do
        name    'generate'
        usage   'generate <subcommand>'
        summary 'Generate a new game configuration'

        description <<-DESCRIPTION
`murder generate` provides a basic setup of a game.
        DESCRIPTION

        required :c, :config, 'Specify a configuration file'

        run do |opts, args, cmd|
          puts cmd.help(:verbose => opts[:verbose])
          exit 0
        end
      end
    end

    module Characters
      def self.command
        @cmd ||= Cri::Command.define do
          name    'characters'
          usage   'characters'
          summary 'Generates all characters profiles'

          runner MURDER::Action::Generate::Characters
        end
      end
    end

    module Links
      def self.command
        @cmd ||= Cri::Command.define do
          name    'links'
          usage   'links'
          summary 'Generates friends and enemies for charaters'

          runner MURDER::Action::Generate::Links
        end
      end
    end

    module Docs
      def self.command
        @cmd ||= Cri::Command.define do
          name    'docs'
          usage   'docs [markdown|pdf]'
          summary 'Generates charaters PDFs or markdown for each player'

          runner MURDER::Action::Generate::Docs
        end
      end
    end
  end
end

MURDER::CLI.command.add_command(MURDER::CLI::Generate.command)
MURDER::CLI::Generate.command.add_command(MURDER::CLI::Generate::Characters.command)
MURDER::CLI::Generate.command.add_command(MURDER::CLI::Generate::Links.command)
MURDER::CLI::Generate.command.add_command(MURDER::CLI::Generate::Docs.command)
