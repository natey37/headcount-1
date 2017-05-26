require "minitest"
require "minitest/autorun"
require "./lib/district_repository.rb"
require "./lib/headcount_analyst.rb"

class IterationOneTest < Minitest::Test
  def test_district_enrollment_relationship_basics
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv",
      :high_school_graduation => "./data/High school graduation rates.csv"}})
    district = dr.find_by_name("GUNNISON WATERSHED RE1J")

    assert_in_delta 0.144, district.enrollment.kindergarten_participation_in_year(2004), 0.005
  end

  def test_enrollment_analysis_basics
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv",
      :high_school_graduation => "./data/High school graduation rates.csv"}})
    ha = HeadCountAnalyst.new(dr)
    assert_in_delta 1.126, ha.kindergarten_participation_rate_variation("GUNNISON WATERSHED RE1J", :against => "TELLURIDE R-1"), 0.005
    assert_in_delta 0.447, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1'), 0.005
  end
end
