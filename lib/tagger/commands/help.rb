require 'tagger'

module Tagger
  module Commands
    class Help < Tagger::Command

      desc('Show help for a command, or this page')

      def call(args, _name)
        Tagger::Help.generate(args)
      end
    end
  end
end
