
class Enrollment
  attr_reader :name, :kindergarten_participation

  def initialize(district, attendance_hash)
    @name = district
    @kindergarten_participation = attendance_hash
  end

  def kindergarten_participation_by_year
    new_hash = {}
      @kindergarten_participation.map do |k, v|
        new_hash[k] = v.round(3)
      end
        return new_hash
  end

  def kindergarten_participation_in_year(year)
    kindergarten_participation_by_year[year]
  end
end
