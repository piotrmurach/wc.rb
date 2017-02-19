# encoding: utf-8

require 'wc/counter'

RSpec.describe WC::Counter, '#stats' do
  let(:fixtures_dir) { File.join(File.dirname(__FILE__), '../fixtures') }
  let(:grim_file) { File.join(fixtures_dir, 'growing_grim.txt') }

  it "calcualtes stats for file's content" do
    content = File.read(grim_file)
    expect(WC::Counter.stats(content)).to match({
      lines: 9,
      words: 88,
      bytes: 496,
      chars: 496
    })
  end
end
