require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/district_repository.rb'

class DistrictRepositoryTest < Minitest::Test


  def district_repository_instance
    dr = DistrictRepository.new
  dr.load_data({
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv",
      :high_school_graduation => "./data/High school graduation rates.csv",
    },
    :statewide_testing => {
      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
      :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
      :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
      :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
    }
  })
        return dr
  end

  def test_dr_class_exists
    d = district_repository_instance
    assert_equal d.class, DistrictRepository
  end

  def test_find_by_name_returns_district_from_case_insensitive_search
    d = district_repository_instance
    assert_equal d.find_by_name("adams county 40"),
                 d.find_by_name("ADAMS COUNTY 40")
  end

  def test_find_by_name_returns_nil_if_no_name_is_found
    d = district_repository_instance
    assert_nil d.find_by_name("NATHAN"), nil
  end

  def test_find_by_name_returns_a_district_object
    d = district_repository_instance

    assert_equal d.find_by_name("academy 20").class, District
  end

  def test_find_all_matching_returns_an_empty_array_for_unmatched_fragment
    d = district_repository_instance
    assert_equal d.find_all_matching("nathan"), []
  end

  def test_find_all_matching_returns_an_array_of_names_matching_fragment
    d = district_repository_instance
    assert_equal d.find_all_matching("adams").map{|d| d.name}.uniq,
                 ["ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J"]
  end

  def test_find_all_matching_returns_district_objects
    d = district_repository_instance
    assert_equal d.find_all_matching("adams").first.class, District
  end

  def test_district_repository_creates_enrollent_instance
      d = district_repository_instance
      district = d.find_by_name("ACADEMY 20")
      assert_equal district.enrollment.kindergarten_participation_in_year(2010),
                    0.436

  end

  def test_graduation_rate_by_year_returns_the_hs_grad_rate_by_year
    d = district_repository_instance
    district = d.find_by_name("academy 20")
    assert_equal district.enrollment.graduation_rate_by_year,
                 { 2010 => 0.895,
                   2011 => 0.895,
                   2012 => 0.89,
                   2013 => 0.914,
                   2014 => 0.898,
                 }

  end

  def test_graduation_rate_in_year_returns_rate_in_given_rate
    d = district_repository_instance
    district = d.find_by_name("adams county 14")
    assert_equal district.enrollment.graduation_rate_in_year(2014),
                 0.659
    assert_nil district.enrollment.graduation_rate_in_year(2001),
                 nil
  end

  def test_statewide_test_is_connected_to_a_single_district
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv",
      },
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
    district = dr.find_by_name("ACADEMY 20")

    assert_equal district.statewide_test.class, StatewideTest
    #statewide_test = district.statewide_test
  end

end
