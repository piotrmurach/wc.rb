# encoding: utf-8

module WC
  class Counter
    def self.stats(file)
      stats = {
        words: 0,
        lines: 0,
        chars: 0,
        bytes: 0
      }

      file.each_line do |line|
        stats[:lines] += 1
        stats[:chars] += line.count(' ') + 1 # newline char
        stats[:bytes] += line.count(' ') + 1 # newline char

        words = line.split
        stats[:words] += words.size

        words.each do |word|
          stats[:chars] += word.chars.size
          stats[:bytes] += word.bytes.size
        end
      end

      stats
    end
  end # Counter
end # WC
