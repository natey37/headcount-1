require_relative 'district_repository'

class UnknownDataError < StandardError
end

class InsufficientInformationError < StandardError
end

class HeadCountAnalyst
  attr_reader :dr_instance

  def initialize(dr_instance)
    @dr_instance = dr_instance
  end

  def kindergarten_participation_rate_variation(district1, district2)
    first_district = get_district_enrollments(district1)
    second_district= get_district_enrollments(district2[:against])
    kg_part_dist_1 = avg_kinder_enrollment(first_district)
    kg_part_dist_2 = avg_kinder_enrollment(second_district)
      return (kg_part_dist_1 / kg_part_dist_2).round(3)
  end

  def kindergarten_participation_rate_variation_trend(district, district2)
    first_district = get_district_enrollments(district)
    second_district = get_district_enrollments(district2[:against])
      return participation_by_year(first_district, second_district)
  end

  def get_district_enrollments(district)
    @dr_instance.find_by_name(district).enrollment
  end

  def data_average(school_data)
    school_data.values.reduce(:+) / school_data.count
  end

  def avg_kinder_enrollment(district)
    data_average(district.kindergarten_participation)
  end

  def participation_by_year(district1, district2)
    dist1 = sorted_data_by_year(district1.kindergarten_participation)
    dist2 = sorted_data_by_year(district2.kindergarten_participation)
    participation = school_data_trends_by_year(dist1, dist2)
  end

  def school_data_trends_by_year(district1, district2)
    school_aspect = {}
    district1.each do |d1_part_in_year|
      district2.each do |d2_part_in_year|
        school_aspect[d1_part_in_year[0]] = (d1_part_in_year[1] /
          d2_part_in_year[1]).round(3) if d1_part_in_year[0] == d2_part_in_year[0]
        end
      end
      return school_aspect
  end

  def sorted_data_by_year(school_data)
    school_data.sort_by{|year, percentage| percentage}
  end

  def kindergarten_participation_against_high_school_graduation(district)
    kinder_part_var = kindergarten_participation_rate_variation(district,{:against => "COLORADO"})
    district_avg = data_average(get_district_enrollments(district).highschool_graduation)
    state_avg = data_average(get_district_enrollments("COLORADO").highschool_graduation)
    hs_grad_var = district_avg / state_avg
      return kinder_part_vs_hs_grad_variation = (kinder_part_var/hs_grad_var).round(3)

  end

  def kindergarten_participation_correlates_with_high_school_graduation(district_area)
    if district_area[:for] == "STATEWIDE"
      percentage_of_true(kinder_part_vs_hs_grad_by_district)
    elsif district_area[:across].class == Array
      percentage_of_true(kinder_part_vs_hs_grad_by_specific_districts(district_area[:across]))
    else
      within_correlation_range(kindergarten_participation_against_high_school_graduation(district_area[:for]))
    end
  end

  def percentage_of_true(districts)
    districts.count(true).to_f / districts.count > 0.7 ? true : false
  end

  def kinder_part_vs_hs_grad_by_specific_districts(districts)
    district_avg = []
    districts.each do |district|
      district_avg << kindergarten_participation_against_high_school_graduation(district)
    end
      return district_avg.map{|var| within_correlation_range(var)}
  end

  def kinder_part_vs_hs_grad_by_district
    kinder_part_vs_hs_grad_percentage = []
    @dr_instance.districts.each do |district|
      if district.name != "COLORADO"
        kinder_part_vs_hs_grad_percentage <<
        kindergarten_participation_against_high_school_graduation(district.name)
      end
    end
      return kinder_part_vs_hs_grad_percentage.map{|var| within_correlation_range(var)}
  end

  def within_correlation_range(kinder_part_vs_hs_grad)
    kinder_part_vs_hs_grad > 0.6 && kinder_part_vs_hs_grad < 1.5 ? true : false
  end

  def top_statewide_test_year_over_year_growth(*args)
    if args[0][:grade] != 8 && args[0][:grade] != 3
      raise InsufficientInformationError
    elsif args[0][:subject] == nil && args[0][:weighting] == nil
      return sort_by_score(year_over_year_growth_for_all_subjects(
               third_and_eighth_grade_scores(args))).first
    elsif args[0][:weighting] != nil
       return sort_by_score(year_over_year_growth_weighted(
                third_and_eighth_grade_scores(args), args[0][:weighting])).first
    else
      if args[0][:top] != nil
        return sort_by_score(year_over_year_growth(
                 third_and_eighth_grade_scores(args),args[0][:subject]))
                 [0...args[0][:top]]
      else
        return sort_by_score(year_over_year_growth(
                 third_and_eighth_grade_scores(args), args[0][:subject])).first
      end
    end
  end

  def test_scores
    test_scores = []
      @dr_instance.districts.each do |d|
          test_scores << d.statewide_test
      end
    test_scores.delete_at(0)
      return test_scores
  end

  def third_and_eighth_grade_scores(*args)
    specific_test_scores = []
      test_scores.each do |district|
        if args[0][0][:grade] == 3
          specific_test_scores << [district.name, district.third_grade]
        elsif args[0][0][:grade] == 8
          specific_test_scores << [district.name, district.eighth_grade]
        end
      end
        return specific_test_scores
  end

  def sort_by_score(scores)
    scores.sort_by{|score| score[1]}.reverse
  end

  def calculate_scores(growth)
    growth.map{|district| [district[0],
      ((district[1].reduce(:+) / district[1].count))]}
  end

  def year_over_year_growth(scores, subject)
    growth = []
      scores.each_with_index do |year, idx|
        subject_years = min_max_by_subject(scores[idx][1], subject)
          subject_years = [2008, 2014] if subject_years == nil
        growth << [scores[idx][0],
                  ((scores[idx][1][subject_years[1]][subject] -
                    scores[idx][1][subject_years[0]][subject]) /
                    (subject_years[1] - subject_years[0])).round(3)]
        end
          return calculate_scores(growth)
  end

  def year_over_year_growth_weighted(scores, weighting)
    growth = []
      scores.each_with_index do |year, idx|
        math_years = min_max_by_subject(scores[idx][1], :math)
          math_years = [2008, 2014] if math_years == nil
        reading_years = min_max_by_subject(scores[idx][1], :reading)
          reading_years = [2008, 2014]  if reading_years == nil
        writing_years = min_max_by_subject(scores[idx][1], :writing)
          writing_years = [2008, 2014] if writing_years == nil
        growth << [scores[idx][0],
                  [(((scores[idx][1][math_years[1]][:math] -
                      scores[idx][1][math_years[0]][:math]) /
                      (math_years[1]-math_years[0])) * weighting[:math]),
                      (((scores[idx][1][reading_years[1]][:reading] -
                      scores[idx][1][reading_years[0]][:reading]) /
                      (reading_years[1]-reading_years[0])) * weighting[:reading]),
                      (((scores[idx][1][writing_years[1]][:writing] -
                      scores[idx][1][writing_years[0]][:writing]) /
                      (writing_years[1]-writing_years[0])) * weighting[:writing])]]
        end
          return growth.map{|district| [district[0], district[1].reduce(:+).round(3)]}
  end

  def year_over_year_growth_for_all_subjects(scores)
    growth = []
      scores.each_with_index do |year, idx|
        math_years = min_max_by_subject(scores[idx][1], :math)
          math_years = [2008, 2014] if math_years == nil
        reading_years = min_max_by_subject(scores[idx][1], :reading)
          reading_years = [2008, 2014] if reading_years == nil
        writing_years = min_max_by_subject(scores[idx][1], :writing)
          writing_years = [2008, 2014] if writing_years == nil
        growth << [scores[idx][0],
                  [((scores[idx][1][math_years[1]][:math] -
                     scores[idx][1][math_years[0]][:math]) /
                     (math_years[1] - math_years[0])),
                     ((scores[idx][1][reading_years[1]][:reading] -
                     scores[idx][1][reading_years[0]][:reading]) /
                     (reading_years[1] - reading_years[0])),
                     ((scores[idx][1][writing_years[1]][:writing] -
                     scores[idx][1][writing_years[0]][:writing]) /
                     (writing_years[1] - writing_years[0]))]]
        end
          return calculate_scores(growth)
  end

  def min_max_by_subject(hash, sub)
    subject = hash.map{|year, subject| [year, subject[sub]]}
    subject1 = subject.delete_if{|arr| arr[1] == 0}
      if subject1.empty? || subject1.count == 1
        return nil
      else
        max = subject1[-1][0]
        min = subject1[0][0]
          return [min, max]
      end
  end
end
