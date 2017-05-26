
class Enrollment
  attr_reader :name, :kindergarten_participation, :highschool_graduation

  def initialize(hash)
    @name = hash[:name]
    @kindergarten_participation = hash[:kindergarten_participation]
    @highschool_graduation = hash[:high_school_graduation]

  end

  def graduation_rate_in_year(year)
    graduation_rate_by_year[year]
  end

  def graduation_rate_by_year
    round(highschool_graduation)
  end

  def kindergarten_participation_by_year
    round(kindergarten_participation)
  end

  def kindergarten_participation_in_year(year)
    kindergarten_participation_by_year[year]
  end

  def round(data)
    new_hash = {}
    data.map{|k, v| new_hash[k] = v.round(3)}
      return new_hash
  end


end
