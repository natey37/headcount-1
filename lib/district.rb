require_relative 'enrollment'

class District
  attr_reader :name, :enrollment, :statewide_testing

  def initialize(hash, enrollment, testing)
    @name = hash[:name]
    @enrollment = enrollment
    @statewide_testing = testing
  end

  def name
    @name.upcase
  end


end
