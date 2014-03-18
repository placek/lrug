#!/usr/bin/env ruby

class String

  def levenstein_distance(other)
    distance = [(0..other.length).to_a]
    self.length.times { |n| distance << [n + 1] }
    1.upto(self.length) do |i|
      1.upto(other.length) do |j|
        cost = (self[i - 1] == other[j - 1]) ? 0 : 1
        distance[i][j] = [distance[i - 1][j] + 1, distance[i][j - 1] + 1, distance[i - 1][j - 1] + cost].min
      end
    end
    distance[self.length][other.length]
  end
end

if __FILE__ == $0
  class LevenstainUI

    def initialize(arguments)
      @first_string, @last_string = ARGV.first, ARGV.last
    end

    def run
      puts @first_string.levenstein_distance(@last_string)
      exit(0)
    end
  end

  LevenstainUI.new(ARGV).run unless ARGV.empty?
  require "test/unit"

  class LevensteinTest < Test::Unit::TestCase
    def test_levenstein_distance_method
      assert_equal(0, "test".levenstein_distance("test"))
      assert_equal(1, "Paweł".levenstein_distance("Gaweł"))
      assert_equal(1, "but".levenstein_distance("buty"))
      assert_equal(2, "foka".levenstein_distance("kotka"))
      assert_equal(2, "Jacek".levenstein_distance("Placek"))
      assert_equal(3, "pastor".levenstein_distance("ciasto"))
      assert_equal(3, "patelnia".levenstein_distance("patera"))
    end
  end
end
