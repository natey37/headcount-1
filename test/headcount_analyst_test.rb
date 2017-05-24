require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/headcount_analyst.rb'

class HeadCountAnalystTest < Minitest::Test

  def set_up
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
      })

     return ha = HeadCountAnalyst.new(dr)
  end
  def test_headcount_analyst_contains_dr_instance
     assert_equal set_up.dr_instance.districts.count, 181
  end

  def test_method_kindergarten_participation_rate_variation_returns_districts_avg_vs_states
    assert_equal set_up.kindergarten_participation_rate_variation('ACADEMY 20',
                 :against => 'COLORADO'), 0.766
  end

  def test_method_kindergarten_participation_rate_variation_returns_districts_avg_vs_another_district
    assert_equal set_up.kindergarten_participation_rate_variation('ACADEMY 20',
                 :against => 'YUMA SCHOOL DISTRICT 1'), 0.447
  end

  def test_kindergarten_participation_rate_variation_trend_returns_variation_by_year
    assert_equal set_up
                .kindergarten_participation_rate_variation_trend('ACADEMY 20',
                :against => 'COLORADO'),
                {2004 => 1.258, 2005 => 0.961, 2006 => 1.05, 2007 => 0.992,
                 2008 => 0.718, 2009 => 0.652, 2010 => 0.681, 2011 => 0.728,
                 2012 => 0.689, 2013 => 0.694, 2014 => 0.661 }

  end
end
