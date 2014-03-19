#!/usr/bin/env ruby
require_relative "ext/levenshtein_distance"

class String
  include LevenshteinDistance
  def levenshtein_distance(other)
    leven(self, other)
  end
end

if __FILE__ == $0
  class LevenshtainUI

    def initialize(arguments)
      @first_string, @last_string = ARGV.first, ARGV.last
    end

    def run
      puts @first_string.levenshtein_distance(@last_string)
      exit(0)
    end
  end

  LevenshtainUI.new(ARGV).run unless ARGV.empty?
  require "test/unit"

  class LevenshteinTest < Test::Unit::TestCase
    def test_levenshtein_distance_method
      assert_equal(0, "test".levenshtein_distance("test"))
      assert_equal(1, "Paweł".levenshtein_distance("Gaweł"))
      assert_equal(1, "but".levenshtein_distance("buty"))
      assert_equal(2, "foka".levenshtein_distance("kotka"))
      assert_equal(2, "Jacek".levenshtein_distance("Placek"))
      assert_equal(3, "pastor".levenshtein_distance("ciasto"))
      assert_equal(3, "patelnia".levenshtein_distance("patera"))
    end
  end
end
