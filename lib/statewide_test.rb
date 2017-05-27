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
   if grade == 3
     return third_grade
   elsif grade == 8
     return eighth_grade
   else
     return "UnknownDataError"
   end
 end

 def proficient_by_race_or_ethnicity(race)
   race = race.to_s.capitalize
   math_scores = {}
     math.each do |year, races|
       math_scores[year] = {math: math[year][race].round(3)}
     end
   reading_scores = {}
    reading.each do |year, races|
      reading_scores[year] = {reading: reading[year][race].round(3)}
    end

    writing_scores = {}
     writing.each do |year, races|
       writing_scores[year] = {writing: writing[year][race].round(3)}
     end

    z = deep_merge(math_scores, reading_scores)
    a = deep_merge(z, writing_scores)
      return a
 end

 def proficient_for_subject_by_race_in_year(subject, race, year)
   race = race.to_s.capitalize
   if !subjects.include?(subject.to_s.capitalize) || !races.include?(race) || !years.include?(year)
     return "UnknownDataError"
   elsif subject == :math
     return math[year][race].round(3)
   elsif subject == :reading
     return reading[year][race].round(3)
   elsif subject == :writing
     return writing[year][race].round(3)
   end

 end

 def proficient_for_subject_by_grade_in_year(subject, grade, year)
   subject = subject.to_s.capitalize
   if !subjects.include?(subject) || !grades.include?(grade) || !years.include?(year)
     return "UnknownDataError"
   elsif grade == 3
     return third_grade[year][subject].round(3)
   elsif grade == 8
     return eighth_grade[year][subject].round(3)
   end
 end

 def deep_merge(h1, h2)
   h1.merge(h2) { |key, h1_elem, h2_elem| deep_merge(h1_elem, h2_elem) }
 end

 def subjects
   ["Math", "Reading", "Writing"]
 end

 def years
   [2008, 2009, 2010, 2011, 2012, 2013, 2014]
 end

 def grades
   [3, 8]
 end

 def races
   ["Asian", "Black", "Pacific_islander", "Hispanic", "Native_american", "Two_or_more", "White"]
 end

end
