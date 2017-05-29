require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/statewide_test_repository.rb'

class StatewideTestRepositoryTest < Minitest::Test

  def set_up
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
      return str
  end

  def test_statewide_test_repository_returns_a_state_wide_test_object
    assert_equal set_up.find_by_name("ACADEMY 20").class, StatewideTest
  end

  def test_method_proficient_by_grade_returns_test_scores_based_on_grade
    assert_equal set_up.find_by_name("ACADEMY 20").proficient_by_grade(8),
                {2008=>{:math=>0.64, :reading=>0.843, :writing=>0.734},
                2009=>{:math=>0.656, :reading=>0.825, :writing=>0.701},
                2010=>{:math=>0.672, :reading=>0.863, :writing=>0.754},
                2011=>{:math=>0.65339, :reading=>0.83221, :writing=>0.74579},
                2012=>{:math=>0.68197, :reading=>0.83352, :writing=>0.73839},
                2013=>{:math=>0.6613, :reading=>0.85286, :writing=>0.75069},
                2014=>{:math=>0.68496, :reading=>0.827, :writing=>0.74789}}

   assert_raises UnknownDataError do
     set_up.find_by_name("ACADEMY 20").proficient_by_grade(1)
   end
  end

  def test_method_proficient_by_race_or_ethnicity_returns_scores_based_on_race
    assert_equal set_up.find_by_name("ACADEMY 20").proficient_by_race_or_ethnicity(:asian),
                { 2011 => {math: 0.817, reading: 0.898, writing: 0.827},
                  2012 => {math: 0.818, reading: 0.893, writing: 0.808},
                  2013 => {math: 0.805, reading: 0.902, writing: 0.811},
                  2014 => {math: 0.800, reading: 0.855, writing: 0.789},
                  }
  end

  def test_method_proficient_for_subject_by_grade_in_year
    assert_equal set_up.find_by_name("Academy 20")
                 .proficient_for_subject_by_grade_in_year(:math, 3, 2008),
                  0.857

    assert_raises UnknownDataError do
                 set_up.find_by_name("Academy 20")
                 .proficient_for_subject_by_grade_in_year(:science, 3, 2008)
    end
  end

  def test_method_proficient_for_subject_by_race_in_year
    assert_equal set_up.find_by_name("Academy 20")
                 .proficient_for_subject_by_race_in_year(:math, :asian, 2012),
                  0.818
    assert_raises UnknownDataError do
                set_up.find_by_name("Academy 20")
                .proficient_for_subject_by_race_in_year(:math, :chinese, 2012)
    end
  end
end
