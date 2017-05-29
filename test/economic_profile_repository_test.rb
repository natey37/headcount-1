require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/economic_profile_repository.rb'

class EconomicProfileRepositoryTest < Minitest::Test



  def set_up
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })
      return epr
    #ep = epr.find_by_name("ACADEMY 20")
  end

  def test_economic_profile_repository_creates_ecomomic_profiles_for_each_district
    assert_equal set_up.find_by_name("Academy 20").class, EconomicProfile
  end

  def test_method_median_household_income_in_year
    x = set_up.find_by_name("Academy 20")
    assert_equal x.median_household_income_in_year(2006),
                  85255.0
    assert_raises UnknownDataError do x.median_household_income_in_year(2001)
                  end
  end

  def test_method_median_household_income_average
    x = set_up.find_by_name("Academy 20")
    assert_equal x.median_household_income_average,
                 87635.4
  end

  def test_children_in_poverty_in_year
    x = set_up.find_by_name("Academy 20")
    assert_equal x.children_in_poverty_in_year(2000),
                 0.031
    assert_raises UnknownDataError do x.children_in_poverty_in_year(1985)
                  end
  end

  def test_method_free_or_reduced_price_lunch_percentage_in_year
      x = set_up.find_by_name("Academy 20")
      assert_equal x.free_or_reduced_price_lunch_percentage_in_year(2012),
                   0.125
      assert_raises UnknownDataError do x.free_or_reduced_price_lunch_percentage_in_year(1985)
                     end
  end

  def test_method_free_or_reduced_price_lunch_number_in_year
    x = set_up.find_by_name("Academy 20")
    assert_equal x.free_or_reduced_price_lunch_number_in_year(2005),
                 1204
   assert_raises UnknownDataError do x.free_or_reduced_price_lunch_percentage_in_year(1985)
                  end
  end

  def test_method_title_i_in_year
    x = set_up.find_by_name("Academy 20")
    assert_equal x.title_i_in_year(2009),
                 0.014
    assert_raises UnknownDataError do x.title_i_in_year(1985)
                  end
  end

  def test_district_contains_an_instance_of_economic_profile
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv",
                    :high_school_graduation => "./data/High school graduation rates.csv",
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
    dr
    assert_equal dr.find_by_name("academy 20").economics.class,
                EconomicProfile
  end
end
