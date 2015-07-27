require 'murder/util/setopts'
require 'pry'

module MURDER
  module Action
    module Generate
      class Characters

        include MURDER::Util::Setopts

        def initialize(opts, argv, cmd)
          @opts = opts
          @argv = argv
          setopts(opts, {
            :config     => :self,
            :trace      => :self
          })
        end

        def call
          binding.pry
          puts 'Hello'
        end
      end
    end
  end
end
