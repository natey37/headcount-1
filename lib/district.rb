require_relative 'enrollment'

class District
  attr_reader :name, :enrollment, :statewide_test, :economics

  def initialize(hash, enrollment, testing, economics)
    @name = hash[:name]
    @enrollment = enrollment
    @statewide_test = testing
    @economics = economics
  end

  def name
    @name.upcase
  end


end
