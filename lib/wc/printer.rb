# encoding: utf-8

module WC
  class Printer
    def initialize(options)
      @lines = options[:lines]
      @words = options[:words]
      @chars = options[:chars]
      @bytes = options[:bytes]
      @formatter = -> (limit) { "%#{limit}d%#{limit}d%#{limit}d" }
    end

    def format(limit, stats)
      @formatter[limit] % [stats[:lines], stats[:words], stats[:chars]]
    end

    def render(filename, stats, limit)
      output = ""

      if @lines
        output << "%#{limit}d" % stats[:lines].to_s
      elsif @words
        output << "%#{limit}d" % stats[:words].to_s
      elsif @chars
        output << "%#{limit}d" % stats[:chars].to_s
      elsif @bytes
        output << "%#{limit}d" % stats[:bytes].to_s
      else
        output << format(limit, stats)
      end
      puts output << " #{filename}"
    end
  end # Printer
end # WC
