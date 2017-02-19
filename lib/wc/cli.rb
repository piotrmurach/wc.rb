# encoding: utf-8

require 'optparse'

require_relative 'counter'
require_relative 'printer'

module WC
  class CLI
    class UsageError < StandardError; end

    class FileNotFoundError < StandardError
      def initialize(filename)
        @filename = filename
      end
      attr_reader :filename
    end

    def about
      <<-EOS
#{$PROGRAM_NAME} 1.0.0
Try `#{$PROGRAM_NAME} -h` for more information.
EOS
    end

    def usage
      <<-EOS
Usage: #{$PROGRAM_NAME} [OPTION] ... [FILE]...
   or: #{$PROGRAM_NAME} [OPTION] ... --files0-from=F
EOS
    end

    def initialize(argv)
      @options = {}
      @files   = parse_options(argv)
      @printer = WC::Printer.new(@options)
    end

    def define_options(parser)
      parser.banner = usage

      parser.separator ''

      parser.on('-c', '--bytes', 'print the byte count') do
        @options[:bytes] = true
      end

      parser.on('-m', '--chars', 'print the character count') do
        @options[:chars] = true
      end

      parser.on('-l', '--lines', 'print the newline count') do
        @options[:lines] = true
      end

      parser.on('-w', '--words', 'print the word count') do
        @options[:words] = true
      end

      parser.on_tail('-h', '--help', 'display this help and exit') do
        puts parser
        exit
      end

      parser.on_tail('--version', 'output version information and exit') do
        puts about
        exit
      end
    end

    def parse_options(argv)
      parser = OptionParser.new

      define_options(parser)

      parser.parse!(argv)
    rescue OptionParser::ParseError => err
      raise WC::CLI::UsageError, err
    end

    def run
      if @files.empty?
        @printer.render(STDIN)
      else
        totals = {
          words: 0,
          lines: 0,
          chars: 0,
          bytes: 0
        }

        files_stats = @files.reduce([]) do |acc, filename|
          begin
            file = ::File.open(filename, 'r')
            stats = WC::Counter.stats(file)
            totals.merge!(stats) { |_, v1, v2| v1 + v2 }

            acc << [filename, stats]
          rescue Errno::ENOENT => err
            raise WC::CLI::FileNotFoundError.new(filename), err
          end
        end

        limit = [8, totals.values.max.to_s.size].max

        files_stats.each do |filename, stats|
          @printer.render(filename, stats, limit)
        end

        @printer.render('total', totals, limit) if files_stats.size > 1
      end
    end
  end # CLI
end # WC
