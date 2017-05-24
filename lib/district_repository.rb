require_relative 'district'
require 'csv'
require 'pry'

class DistrictRepository
  attr_reader :districts
  def initialize()

  end

  def load_data(args)
    file_name = args[:enrollment][:kindergarten]

    data = []
    CSV.foreach(file_name, :headers => true) do |row|
      data << row
    end
    @districts = []
    district_names = data.map{|row| row[0]}.uniq
      district_names.each do |name|
        districts << District.new({:name => name})
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
