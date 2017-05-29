class UnknownDataError < StandardError
end

class StatewideTest
  attr_reader :third_grade, :eighth_grade, :name, :math, :reading, :writing
  def initialize(district, third, eighth, math, reading, writing)
    @name = district
    @third_grade = third
    @eighth_grade = eighth
    @math = math
    @reading = reading
    @writing = writing
 end

 def proficient_by_grade(grade)
   return third_grade if grade == 3
   return eighth_grade if grade == 8
     raise UnknownDataError
 end

def scores_by_race(data, race, subject)
  subject1 = {}
    data.each do |year, races|
      subject1[year] = {subject => data[year][race].round(3)}
    end
      return subject1
end

 def proficient_by_race_or_ethnicity(race)
  #  math_scores = {}
  #    math.each do |year, races|
  #      math_scores[year] = {math: math[year][race].round(3)}
  #    end
  #  reading_scores = {}
  #   reading.each do |year, races|
  #     reading_scores[year] = {reading: reading[year][race].round(3)}
  #   end
   #
  #   writing_scores = {}
  #    writing.each do |year, races|
  #      writing_scores[year] = {writing: writing[year][race].round(3)}
  #    end

    math = scores_by_race(@math, :asian, :math)
    reading = scores_by_race(@reading, :asian, :reading)
    writing = scores_by_race(@writing, :asian, :writing)

    math_and_reading = deep_merge(math, reading)
    final_scores_by_race = deep_merge(math_and_reading, writing)
      return final_scores_by_race
 end

 def proficient_for_subject_by_race_in_year(subject, race, year)
   if !subjects.include?(subject) || !races.include?(race) || !years.include?(year)
     raise UnknownDataError
   elsif subject == :math
     return math[year][race].round(3)
   elsif subject == :reading
     return reading[year][race].round(3)
   elsif subject == :writing
     return writing[year][race].round(3)
   end

 end

 def proficient_for_subject_by_grade_in_year(subject, grade, year)
   if !subjects.include?(subject) || !grades.include?(grade) || !years.include?(year)
     raise UnknownDataError
   elsif grade == 3
     score = third_grade[year][subject].round(3)
       score == 0.0 ? "N/A" : score
   elsif grade == 8
     score = eighth_grade[year][subject].round(3)
       score == 0.0 ? "N/A" : score
   end
 end

 def deep_merge(h1, h2)
   h1.merge(h2) { |key, h1_elem, h2_elem| deep_merge(h1_elem, h2_elem) }
 end

 def subjects
   [:math, :reading, :writing]
 end

 def years
   [2008, 2009, 2010, 2011, 2012, 2013, 2014]
 end

 def grades
   [3, 8]
 end

 def races
   [:asian, :black, :pacfic_islander, :hispanic, :native_american, :two_or_more, :white]
 end

end
