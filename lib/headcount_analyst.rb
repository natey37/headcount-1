require_relative 'district_repository'

class HeadCountAnalyst
  attr_reader :dr_instance

  def initialize(dr_instance)
    @dr_instance = dr_instance
  end

  def kindergarten_participation_rate_variation(district, hash)
    district1 = district(district)
    district2 = district(hash[:against])
    average1 = average(district1)
    average2 = average(district2)
      return (average1 / average2).round(3)
  end

  def kindergarten_participation_rate_variation_trend(district, hash)
    district1 = district(district)
    district2 = district(hash[:against])
      return participation_by_year(district1, district2)
  end

  def district(district)
    @dr_instance.find_by_name(district).enrollment
  end

  def average(district)
    district.kindergarten_participation.values
    .reduce(:+) / district.kindergarten_participation.count
  end

  def participation_by_year(district1, district2)
    participation = {}
    dist1 = district1.kindergarten_participation.sort_by{|k,v| k}
    dist2 = district2.kindergarten_participation.sort_by{|k,v| k}
      dist1.each do |arr1|
        dist2.each do |arr2|
          if arr1[0] == arr2[0]
            participation[arr1[0]] = (arr1[1] / arr2[1]).round(3)
          end
        end
      end
        return participation
  end
end
