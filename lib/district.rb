class District
  attr_reader :name

  def initialize(district)
    @name = district["Location"]
  end

  def name
    @name.upcase
  end


end
