require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/headcount_analyst.rb'

class HeadCountAnalystTest < Minitest::Test

  def set_up
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/data/kindergarteners_in_full_day_programs.csv",
        :high_school_graduation => "./test/data/highschool_graduation_rates.csv"
      },
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      },
        :economic_profile => {
          :median_household_income => "./data/Median household income.csv",
          :children_in_poverty => "./data/School-aged children in poverty.csv",
          :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
          :title_i => "./data/Title I students.csv"
        }
      })

     return ha = HeadCountAnalyst.new(dr)
  end

  def test_headcount_analyst_contains_dr_instance
     assert_equal set_up.dr_instance.districts.count, 3
  end

  def test_method_kindergarten_participation_rate_variation_returns_districts_avg_vs_states
    assert_equal set_up.kindergarten_participation_rate_variation('ACADEMY 20',
                 :against => 'COLORADO'), 0.766
  end

  #def test_method_kindergarten_participation_rate_variation_returns_districts_avg_vs_another_district
  #  assert_equal set_up.kindergarten_participation_rate_variation('ACADEMY 20',
  #               :against => 'YUMA SCHOOL DISTRICT 1'), 0.447
  #end

  def test_kindergarten_participation_rate_variation_trend_returns_variation_by_year
    assert_equal set_up
                .kindergarten_participation_rate_variation_trend('ACADEMY 20',
                :against => 'COLORADO'),
                {2004 => 1.258, 2005 => 0.961, 2006 => 1.05, 2007 => 0.992,
                 2008 => 0.718, 2009 => 0.652, 2010 => 0.681, 2011 => 0.728,
                 2012 => 0.689, 2013 => 0.694, 2014 => 0.661 }

  end

  def test_method_kg_partic_against_hs_graduation_returns_kg_grad_variance
    assert_equal set_up
                .kindergarten_participation_against_high_school_graduation('ACADEMY 20'),
                0.641
  end

  def test_method_kindergarten_participation_correlates_with_high_school_graduation
    assert_equal set_up
                 .kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20'),
                 true
  end

  def test_method_kindergarten_participation_correlates_with_high_school_graduation
    assert_equal set_up
                 .kindergarten_participation_correlates_with_high_school_graduation(:for => 'STATEWIDE'),
                 false
  end

  def test_method_kindergarten_participation_correlates_with_high_school_graduation
    assert_equal set_up
                .kindergarten_participation_correlates_with_high_school_graduation(:across => ["academy 20", 'ADAMS-ARAPAHOE 28J']),
                false
  end

  def test_method_top_statewide_test_year_over_year_growth_tests_growth_for_grade

    assert_equal set_up.top_statewide_test_year_over_year_growth(grade: 8, subject: :math),
                 ["ACADEMY 20", 0.007]
  end

  def test_method_top_statewide_test_year_over_year_growth_tests_growth_for_top_districts
    assert_equal set_up.top_statewide_test_year_over_year_growth(grade: 8, top: 3, subject: :math),
              [["ACADEMY 20", 0.007], ["ADAMS-ARAPAHOE 28J", -0.005]]
  end

  def test_method_top_statewide_test_year_over_year_growth_tests_growth_based_on_weight
    assert_equal set_up.top_statewide_test_year_over_year_growth(grade: 8, :weighting => {:math => 0.5, :reading => 0.5, :writing => 0.0}),
                 ["ACADEMY 20", 0.002]
  end
end
