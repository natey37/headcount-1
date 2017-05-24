class District
  attr_reader :name

  def initialize(hash)
    @name = hash[:name]
  end

  def name
    @name.upcase
  end


end
