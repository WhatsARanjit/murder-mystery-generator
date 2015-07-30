require 'murder-mystery-generator'
require 'cri'

module MURDER::CLI
  def self.command
    @cmd ||= Cri::Command.define do
      name    'murder'
      usage   'murder <subcommand> [options]'
      summary 'Sweet gem to create a great party game.'
      description <<-EOD
        murder is a suite of commands to help deploy and manage plots and
        character profiles for murder mystery dinners.
      EOD

     flag :h, :help, 'Show help for this command' do |value, cmd|
        verbose = (ARGV.include?('-v') || ARGV.include?('--verbose'))
        puts cmd.help(:verbose => verbose)
        exit 0
      end

      flag :t, :trace, 'Display stack traces on application crash'

      run do |opts, args, cmd|
        puts cmd.help(:verbose => opts[:verbose])
        exit 0
      end
    end
  end
end

require 'murder/cli/rename'
require 'murder/cli/generate'
require 'murder/cli/graph'
