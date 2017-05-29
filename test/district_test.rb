require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/district_repository.rb'

class DistrictTest< Minitest::Test

  def district_repository_instance
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
      })
        return dr
  end

  def test_name_returns_the_uppercase_name_of_the_district
    d = district_repository_instance
    assert_equal d.find_by_name("academy 20").name, "ACADEMY 20"
  end

end
