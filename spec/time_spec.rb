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
    assert_true(File.foreach("output.txt").grep(/Channel2 -- Recording -- ending at 2016-06-14 22:47:00 -0400:0.02 hours/).any?)
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

  def test_time_after_all_recordings_current_recording_should_be_zero
    Time.stubs(:now).returns(Time.new(2017,6,14,22,46))
    data = Timer.new.calculate
    assert_equal((0.0).round(2), data["current_recording_gb"])
  end

  def test_time_before_all_recordings_projected_recordings_are_all_accounted_for
    Time.stubs(:now).returns(Time.new(2015,6,14,22,46))
    data = Timer.new.calculate
    assert_equal((1.0*5.0/60.0+2.0*5.0/60.0).round(2), data["projected_recording_gb"])
  end

  def test_time_part_way_through_recording_one_projected #10:41
    Time.stubs(:now).returns(Time.new(2016,6,14,22,41))
    data = Timer.new.calculate
    assert_equal((1.0*4.0/60.0+2.0*5.0/60.0).round(2), data["projected_recording_gb"])
  end

  def test_time_part_way_through_both_recordings_projected #10:44
    Time.stubs(:now).returns(Time.new(2016,6,14,22,44))
    data = Timer.new.calculate
    assert_equal((1.0*1.0/60.0+2.0*3.0/60.0).round(2), data["projected_recording_gb"])
  end
  def test_time_part_way_through_one_recording_projected #10:46
    Time.stubs(:now).returns(Time.new(2016,6,14,22,46))
    data = Timer.new.calculate
    assert_equal((2.0*1.0/60.0).round(2), data["projected_recording_gb"])
  end

  def test_time_after_all_recordings #Next day
    Time.stubs(:now).returns(Time.new(2016,6,15,22,46))
    data = Timer.new.calculate
    assert_equal((0.0).round(2), data["projected_recording_gb"])
  end

  def test_time_in_seconds_for_projected_can_be_calculated
    Time.stubs(:now).returns(Time.new(2015,4,13,10,15))
    data = Timer.new.calculate
    assert_equal(10*60, data["projected_recording_seconds"])
  end

  def test_time_in_seconds_when_only_partial_recordings_can_be_calculated
    Time.stubs(:now).returns(Time.new(2016,6,14,22,43))
    data = Timer.new.calculate
    seconds_representing_six_minutes = 6*60
    assert_equal(seconds_representing_six_minutes, data["projected_recording_seconds"])
  end

  def test_change_in_recording_status_cause_return_of_update_true
    Time.stubs(:now).returns(Time.new(2016,6,14,22,43))
    Timer.new.calculate
    Time.stubs(:now).returns(Time.new(2016,6,14,22,46))
    data = Timer.new.calculate
    assert_true(data["perform_update"])
  end

  def test_that_no_changes_result_in_no_update
    Time.stubs(:now).returns(Time.new(2016,6,14,22,40))
    Timer.new.calculate
    Time.stubs(:now).returns(Time.new(2016,6,14,22,41))
    data = Timer.new.calculate
    assert_false(data["perform_update"])
  end

  def test_that_after_fifteen_minutes_the_update_will_occur
    Time.stubs(:now).returns(Time.new(2014,5,15,19,30))
    data = Timer.new.calculate
    assert_true(data["perform_update"])
    Time.stubs(:now).returns(Time.new(2014,5,15,19,46))
    data = Timer.new.calculate
    `cat lastupdate.json`
    assert_true(data["perform_update"])
  end
end
