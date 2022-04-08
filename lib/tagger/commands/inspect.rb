require 'tagger'
require 'wahwah'

module Tagger
  module Commands
    class Inspect < Tagger::Command
      command_name('inspect')
      desc('Inspect a file')
      long_desc(<<~LONGDESC)
        Inspect the tags inside a music file.
      LONGDESC
      usage('[path/to/file.flac]')
      example('~/Music/The Microphones/The Glow Pt.2/01 I Want Wind to Blow.flac', "inspect the tags in 'I want wind to blow'")

      class Opts < CLI::Kit::Opts
        def file
          position!
        end

        def full
          flag(short: '-f', long: '--full', desc: 'Show all tags (including missing)')
        end
      end

      def invoke(opts, _name)
        tag = WahWah.open(opts.file)
        track_info = "#{tag.track} #{"(out of #{tag.track_total})" unless tag.track_total.nil?}"
        
        items = []
        items << ["Nr", track_info] if tag.track || opts.full
        items << ["Title", tag.title] if tag.title || opts.full
        items << ["Artist", tag.artist] if tag.artist || opts.full
        items << ["Composer", tag.composer] if tag.composer || opts.full
        items << ["Album", tag.album] if tag.album || opts.full
        items << ["Date", tag.year] if tag.year || opts.full
        items << ["Album artist", tag.albumartist] if tag.albumartist || opts.full
        items << ["Genre", tag.genre] if tag.genre || opts.full
        items << ["", ""] # Add an empty line before technical info
        items << ["Duration", "#{(tag.duration / 60).round}m #{(tag.duration % 60).round}s"]
        items << ["Type", opts.file.split('.').last]
        items << ["Sample rate", tag.sample_rate == 44100 ? 44.1 : (tag.sample_rate / 1000)]
        items << ["Bit depth", tag.bit_depth] if tag.bit_depth 

        max_len = items.map(&:first).map(&:length).max
        
        CLI::UI::Frame.open(opts.file.split('/').last, frame_style: :bracket, timing: nil) do
          items.each do |name, value|
            STDOUT.write(CLI::UI.fmt("{{command:#{name.ljust(max_len)}}}  #{value}\n"))
          end
        end
      end
    end
  end
end
