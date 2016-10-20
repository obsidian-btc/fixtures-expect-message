require_relative './test_init'

require 'test_bench/cli'

argv = ARGV.empty? ? %w(test/bench) : ARGV
TestBench::CLI.(argv) or exit 1
