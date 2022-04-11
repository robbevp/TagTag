require 'tagger'
require 'wahwah'
require 'pathname'

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
        def files
          rest
        end

        def full
          flag(short: '-f', long: '--full', desc: 'Show all tags (including missing)')
        end
      end

      def invoke(opts, _name)
        if opts.files.length == 0
          STDERR.puts CLI::UI.fmt("{{red:Please pass at least one file to inspect.}}")
          exit!
        end

        opts.files.each do |file|
          items = get_track_info(file, full: opts.full)
          max_len = items.map(&:first).map(&:length).max
          
          CLI::UI::Frame.open(file.split('/').last, frame_style: :bracket, timing: nil) do
            items.each do |name, value|
              STDOUT.write(CLI::UI.fmt("{{command:#{name.ljust(max_len)}}}  #{value}\n"))
            end
          end
        end
      end

      def get_track_info(file, full: false)
        tag = WahWah.open(file)
        track_info = "#{tag.track} #{"(out of #{tag.track_total})" unless tag.track_total.nil?}"
        
        items = []
        items << ["Nr", track_info] if tag.track || full
        items << ["Title", tag.title] if tag.title || full
        items << ["Artist", tag.artist] if tag.artist || full
        items << ["Composer", tag.composer] if tag.composer || full
        items << ["Album", tag.album] if tag.album || full
        items << ["Date", tag.year] if tag.year || full
        items << ["Album artist", tag.albumartist] if tag.albumartist || full
        items << ["Genre", tag.genre] if tag.genre || full
        items << ["", ""] # Add an empty line before technical info
        items << ["Duration", "#{(tag.duration / 60).round}m #{(tag.duration % 60).round}s"]
        items << ["Type", file.split('.').last]
        items << ["Sample rate", tag.sample_rate == 44100 ? 44.1 : (tag.sample_rate / 1000)]
        items << ["Bit depth", tag.bit_depth] if tag.bit_depth 

        items
      end
    end
  end
end
