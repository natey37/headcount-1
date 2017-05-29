require_relative 'district_repository'
require_relative 'statewide_test'
require 'csv'
require 'pry'

class StatewideTestRepository
  attr_reader :statewidetests

  def load_data(args)
    third_grade = args[:statewide_testing][:third_grade]
    eighth_grade = args[:statewide_testing][:eighth_grade]
    math = args[:statewide_testing][:math]
    reading = args[:statewide_testing][:reading]
    writing = args[:statewide_testing][:writing]

    third = school_test_scores(third_grade)
    eighth = school_test_scores(eighth_grade)
    math = school_test_scores_by_race(math)
    reading = school_test_scores_by_race(reading)
    writing = school_test_scores_by_race(writing)
    @statewidetests = []
      district_names(third_grade).each do |district|
        statewidetests << StatewideTest.new(
                          district,
                          third[district],
                          eighth[district],
                          math[district],
                          reading[district],
                          writing[district])
      end
        return statewidetests
  end

  def collect_data(file)
    data = []
      CSV.foreach(file, :headers => true) do |row|
        data << row
      end
        return data
  end

  def district_names(file)
    collect_data(file).map{|row| row[0]}.uniq
  end

  def district_names_as_hash_keys(file)
    names = {}
    district_names(file).each{|name| names[name] = {} }
      return names
  end

  def deep_merge(h1, h2)
    h1.merge(h2) { |key, h1_elem, h2_elem| deep_merge(h1_elem, h2_elem) }
  end

  def getting_school_test_scores_by_race(file, race)
    scores = district_names_as_hash_keys(file)
    collect_data(file).each do |row|
        if row[1] == race
        scores[row[0]].store(row[2].to_i, {row[1].downcase.to_sym => row[4].to_f})
        end
     end
      return scores
  end

  def school_test_scores_by_race(file)
    white = getting_school_test_scores_by_race(file, "White")
    asian = getting_school_test_scores_by_race(file, "Asian")
    black = getting_school_test_scores_by_race(file, "Black")
    hawaiian = getting_school_test_scores_by_race(file, "Hawaiian/Pacific Islander")
    hispanic = getting_school_test_scores_by_race(file, "Hispanic")
    native_american = getting_school_test_scores_by_race(file, "Native American")
    two_or_more = getting_school_test_scores_by_race(file, "Two or more")
    wa= deep_merge(white, asian)
    wab = deep_merge(wa, black)
    wabh = deep_merge(wab, hawaiian)
    wabhh = deep_merge(wabh, hispanic)
    wabhhn = deep_merge(wabhh, native_american)
    final_scores_by_race = deep_merge(wabhhn, two_or_more)
      return final_scores_by_race
  end

  def getting_school_test_scores(file, subject)
    scores = district_names_as_hash_keys(file)
    collect_data(file).each do |row|
      if row[1] == subject
        scores[row[0]].store(row[2].to_i, {row[1].downcase.to_sym => row[4].to_f})
      end
    end
      return scores
  end

  def school_test_scores(file)
    math = getting_school_test_scores(file, "Math")
    writing = getting_school_test_scores(file, "Writing")
    reading = getting_school_test_scores(file, "Reading")
    x = deep_merge(math, reading)
      return schools_with_test_scores = deep_merge(x, writing)
  end

  def find_by_name(name)
    statewidetests.each do |swt|
      return swt if swt.name.upcase == name.upcase
    end
  end

end
