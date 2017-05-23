require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/district_repository.rb'

class DistrictRepositoryTest < Minitest::Test


  def district_repository_instance
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
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


end
