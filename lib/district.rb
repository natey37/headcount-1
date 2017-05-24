require_relative 'enrollment'

class District
  attr_reader :name, :enrollment

  def initialize(hash, enrollment)
    @name = hash[:name]
    @enrollment = enrollment
  end

  def name
    @name.upcase
  end


end
