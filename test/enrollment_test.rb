require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/enrollment_repository.rb'

class EnrollmentRepositoryTest < Minitest::Test


  def enrollment_repository_instance
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
      })
        return er
  end


  def test_method_find_by_name_returns_enrollments_matching_that_name
    er = enrollment_repository_instance
    assert_equal er.find_by_name("academy 20").kindergarten_participation,
                   {2007=>0.39159, 2006=>0.35364, 2005=>0.26709, 2004=>0.30201,
                    2008=>0.38456, 2009=>0.39, 2010=>0.43628, 2011=>0.489,
                    2012=>0.47883, 2013=>0.48774, 2014=>0.49022}
    assert_equal er.find_by_name("academy 20").class, Enrollment
  end

  def test_method_kindergarten_participation_by_year_returns_a_hash
    er = enrollment_repository_instance
    e = er.find_by_name("academy 20")
    assert_equal e.kindergarten_participation_by_year.count, 11
    assert_equal e.kindergarten_participation_by_year[2007], 0.392
  end

  def test_method_kindergarten_participation_in_year_returns_partic_by_year_given
    er = enrollment_repository_instance
    e = er.find_by_name("adams county 14")
    assert_equal e.kindergarten_participation_in_year(2007), 0.306
    assert_nil e.kindergarten_participation_in_year(2001), nil
  end
end
