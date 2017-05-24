
class Enrollment
  attr_reader :name, :kindergarten_participation

  def initialize(hash)
    @name = hash[:name]
    @kindergarten_participation = hash[:kindergarten_participation]
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
