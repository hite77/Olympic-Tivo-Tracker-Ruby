require_relative '../average.rb'
require "test/unit"

class TestAverage < Test::Unit::TestCase
  def setup
    if File.exist?("averages.json")
      File.delete("averages.json")
    end
  end

  def test_can_average_gb_per_hour 
    assert_equal(1.0, Average.new.calculate("1:00:00", "1.00 GB", "FMHD") )
  end

  def test_can_average_multiple_hour_given_gb
    assert_equal(2.5/3.0, Average.new.calculate("3:00:00", "2.5 GB", "RVLTHD") )
  end

  def test_can_average_multiple_minues_given_gb
    assert_equal(3.4/(2.0+15.0/60.0), Average.new.calculate("2:15:00", "3.4 GB", "MTVLIVE") )
  end

  def test_can_average_multiple_seconds_given_gb
    assert_equal(0.98/(23.0/60.0+42.0/(60.0*60.0)), Average.new.calculate("0:23:42", "0.98 GB", "TMCHD"))
  end

  def test_can_average_gb_per_hour_given_mb
    assert_equal(728.0 / 1024.0, Average.new.calculate("1:00:00", "728 MB", "LMNHD"))
  end

  def test_can_average_multiple_hour_given_mb
    assert_equal(500.0 / 1024.0 / 2.0, Average.new.calculate("2:00:00", "500 MB", "ESPNHD"))
  end

  def test_can_average_multiple_minutes_given_mb
    assert_equal(333.0/1024.0/(2.0+53.0/60.0), Average.new.calculate("2:53:00", "333 MB", "SUNDHD"))
  end

  def test_can_average_multiple_seconds_given_mb
    assert_equal(444.0/1024.0/(2.0+53.0/60.0+26.0/3600.0), Average.new.calculate("2:53:26", "444 MB", "IFCHD"))
  end

  def test_can_average_and_recall
    averager = Average.new
    averager.calculate("1:00:00", "1.0 GB","AMCHD")
    averager.calculate("2:00:00", "1.0 GB","AMCHD")
    assert_equal(0.75, averager.retrieve("AMCHD"))
  end

  def test_can_average_and_recall_for_multiple_channels
    averager = Average.new
    averager.calculate("1:00:00", "1.0 GB", "AMCHD")
    averager.calculate("2:00:00", "1.0 GB", "IFCHD")
    assert_equal(1.0, averager.retrieve("AMCHD"))
    assert_equal(0.5, averager.retrieve("IFCHD"))
  end

  def test_can_persist_averages_and_recall_for_multiple_channels
    averager = Average.new
    averager.calculate("1:00:00", "1.0 GB", "AMCHD");
    averager.calculate("2:00:00", "1.0 GB", "IFCHD");
    averager = Average.new
    assert_equal(1.0, averager.retrieve("AMCHD"))
    assert_equal(0.5, averager.retrieve("IFCHD"))
  end

  def test_can_average_multiple_channels_and_return_average_of_all_for_channels_not_recorded
    averager = Average.new
    averager.calculate("1:00:00","1.0 GB","AMCHD")
    averager.calculate("2:00:00","1.0 GB","TWO");
    averager.calculate("3:00:00","1.0 GB","THREE");
    assert_equal((1.0+0.5+1.0/3.0)/3, averager.retrieve("ANOTHER"))
  end
end
