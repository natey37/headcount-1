require './lib/district.rb'
require 'csv'
require 'pry'

class DistrictRepository
  attr_reader :districts
  def initialize()

  end

  def load_data(args)
    file_name = args[:enrollment][:kindergarten]

    @districts = []
    CSV.foreach(file_name, :headers => true) do |district|
      districts << District.new(district)
    end

  end

  def find_by_name(name)
    districts.each do |d|
      return d if d.name.upcase == name.upcase
    end
      nil
  end

  def find_all_matching(fragment)
    dist = []
    districts.each do |d|
      dist << d if d.name.upcase.include?(fragment.upcase)
    end
     return dist
  end
end
