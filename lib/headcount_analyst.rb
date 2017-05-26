require_relative 'district_repository'

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
        within_correlation_range(kindergarten_participation_against_high_school_graduation(district_area))
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
        hs_grad_percentage <<
        kindergarten_participation_against_high_school_graduation(district.name)
      end
    end
      return kinder_part_vs_hs_grad_percentage.map{|var| within_correlation_range(var)}
  end

  def within_correlation_range(kinder_part_vs_hs_grad)
    kinder_part_vs_hs_grad > 0.6 && kinder_part_vs_hs_grad < 1.5 ? true : false
  end
end
