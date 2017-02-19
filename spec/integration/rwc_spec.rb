# encoding: utf-8

require 'open3'

RSpec.describe 'integration tests' do
  let(:fixtures_dir) { File.join(File.dirname(__FILE__), '../fixtures') }
  let(:grim_file) { File.join(fixtures_dir, 'growing_grim.txt') }
  let(:sea_file) { File.join(fixtures_dir, 'the_sea.txt') }

  it "rwc [file] == wc [file]" do
    wc_out = `wc #{grim_file}`
    rwc_out = `exe/rwc #{grim_file}`

    expect(rwc_out).to eq(wc_out)
  end

  it "rwc [file1 file2] == wc [file1 file2]" do
    wc_out = `wc #{sea_file} #{grim_file}`
    rwc_out = `exe/rwc #{sea_file} #{grim_file}`

    expect(rwc_out).to eq(wc_out)
  end

  it "rwc < file == wc < file" do
    wc_out = `wc #{sea_file} #{grim_file}`
    rwc_out = `exe/rwc #{sea_file} #{grim_file}`

    expect(rwc_out).to eq(wc_out)
  end

  it "rwc -l == rwc -l" do
    wc_out = `wc -l #{sea_file}`
    rwc_out = `exe/rwc -l #{sea_file}`

    expect(rwc_out).to eq(wc_out)
  end

  it "rwc -l [file1 file2] == wc -l [file1 file2]" do
    wc_out = `wc -l #{sea_file} #{grim_file}`
    rwc_out = `exe/rwc -l #{sea_file} #{grim_file}`

    expect(rwc_out).to eq(wc_out)
  end

  it "rwc -w == wc -w" do
    wc_out = `wc -w #{sea_file}`
    rwc_out = `exe/rwc -w #{sea_file}`

    expect(rwc_out).to eq(wc_out)
  end

  it "rwc -m == wc -m" do
    wc_out = `wc -m #{sea_file}`
    rwc_out = `exe/rwc -m #{sea_file}`

    expect(rwc_out).to eq(wc_out)
  end

  it "rwc -c == wc -c" do
    wc_out = `wc -c #{sea_file}`
    rwc_out = `exe/rwc -c #{sea_file}`

    expect(rwc_out).to eq(wc_out)
  end

  it "rwc exit code == wc exit code" do
    `wc -c #{sea_file}`
    wc_process = $?
    `exe/rwc -c #{sea_file}`
    rwc_process = $?

    expect(rwc_process.exitstatus).to eq(wc_process.exitstatus)
  end

  it "rwc invalid_file == wc invalid_file" do
    wc_out, wc_err, wc_process    = Open3.capture3("wc invalid_file")
    rwc_out, rwc_err, rwc_process = Open3.capture3("exe/rwc invalid_file")

    expect(rwc_process.exitstatus).to eq(wc_process.exitstatus)

    expect(rwc_out).to eq(wc_out)
    expect(rwc_err).to match(/#{wc_err}/)
  end

  it "rwc -z == wc -z" do
    wc_out, _, wc_process     = Open3.capture3("wc -z #{sea_file}")
    rwc_out, rwc_err, rwc_process  = Open3.capture3("exe/rwc -z #{sea_file}")

    expect(rwc_process.exitstatus).to eq(wc_process.exitstatus)

    expect(rwc_out).to eq(wc_out)
    expect(rwc_err).to match('invalid option: -z')
  end
end
