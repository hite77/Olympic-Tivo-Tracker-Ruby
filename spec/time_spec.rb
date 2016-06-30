require "test/unit"
require "mocha/test_unit"
require 'fileutils'
require_relative '../time.rb'

class TestTest < Test::Unit::TestCase
  def setup
    FileUtils.cp('test.csv', 'backup_test.csv')
    FileUtils.cp('spec/test_data.csv', 'test.csv')
    FileUtils.cp('averages.json', 'backup_averages.json')
    FileUtils.cp('spec/test_averages_data.json', 'averages.json')
  end

  def teardown
    FileUtils.cp('backup_test.csv', 'test.csv')
    FileUtils.cp('backup_averages.json', 'averages.json')
  end

  def test_time_during_recording_will_show_that_it_is_recording
    Time.stubs(:now).returns(Time.new(2016,6,14,22,43))
    Timer.new.calculate
    assert_true(File.foreach("output.txt").grep(/Channel1 -- Recording -- ending at 2016-06-14 22:45:00 -0400:0.05 hours/).any?)
    assert_true(File.foreach("output.txt").grep(/Channel2 -- Recording -- ending at 2016-06-14 22:47:00 -0400:0.016666666666666666 hours/).any?)
  end

  def test_time_after_recording_will_not_show_that_it_is_recording
    Time.stubs(:now).returns(Time.new(2016,7,14,10,22))
    Timer.new.calculate
    assert_false(File.foreach("output.txt").grep(/Recording Start:22:40/).any?)
    assert_false(File.foreach("output.txt").grep(/Recording Start:22:43/).any?)
  end

  def test_time_current_recording_works_when_time_is_in_middle_of_all_recordings
    Time.stubs(:now).returns(Time.new(2016,6,14,22,43))
    data = Timer.new.calculate
    assert_equal((1.0*(3.0/60.0)+2.0*(1.0/60.0)).round(2), data["current_recording_gb"])## 5 minutes Channel 1, 5 minutes Channel 2
  end

  def test_time_current_recording_works_when_time_is_before_all_recordings
    Time.stubs(:now).returns(Time.new(2016,6,13,9,23))
    data = Timer.new.calculate
    assert_equal(0.00, data["current_recording_gb"])
  end

  def test_time_current_recording_works_when_time_is_only_during_one_recording
    Time.stubs(:now).returns(Time.new(2016,6,14,22,46))
    data = Timer.new.calculate
    assert_equal((2.0*(4.0/60.0)).round(2), data["current_recording_gb"])
  end

  ### Test that time is after all recordings, make sure it is 0

  ### Test that projected time is right, for all recordings, for some recordings (include part that has recorded so far), and that after all recordings are done, then projected is 0.
end
