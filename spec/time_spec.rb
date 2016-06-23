require "test/unit"
require "mocha/test_unit"
require_relative '../time.rb'

class TestTest < Test::Unit::TestCase
  def setup
    #copy test.csv from spec over to main folder
  end

  def test_time_during_recording_will_show_that_it_is_recording
    Time.stubs(:now).returns(Time.new(2016,6,14,22,43))
    Timer.new
    assert_true(File.foreach("output.txt").grep(/Channel1 -- Recording -- ending at 2016-06-14 22:45:00 -0400:0.05 hours/).any?)
    assert_true(File.foreach("output.txt").grep(/Channel2 -- Recording -- ending at 2016-06-14 22:47:00 -0400:0.016666666666666666 hours/).any?)
  end

  def test_time_after_recording_will_not_show_that_it_is_recording
    Time.stubs(:now).returns(Time.new(2016,7,14,10,22))
    Timer.new
    assert_false(File.foreach("output.txt").grep(/Recording Start:22:40/).any?)
    assert_false(File.foreach("output.txt").grep(/Recording Start:22:43/).any?)
  end
end
