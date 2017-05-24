require_relative 'district'
require_relative 'enrollment'
require 'csv'
require 'pry'

class DistrictRepository
  attr_reader :districts, :district
  def initialize()

  end

  def load_data(args)
    @district = args[:enrollment][:kindergarten]
    @districts = []
    ke = kindergarten_enrollment
      district_names.each do |name|
          districts << District.new({:name => name},
                       Enrollment.new(:name => name,
                       :kindergarten_participation => ke[name]))
       end
  end
  def collect_data
    data = []
      CSV.foreach(district, :headers => true) do |row|
        data << row
      end
        return data
  end

  def district_names
    collect_data.map{|row| row[0]}.uniq
  end

  def kindergarten_enrollment
    enroll = {}
      district_names.each do |name|
        enroll[name] = {}
      end
      collect_data.each do |row|
        enroll[row[0]].store(row[1].to_i, row[3].to_f)
      end
        return enroll
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
