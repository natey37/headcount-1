class District
  attr_reader :name

  def initialize(district)
    @name = district["Location"]
  end



end
