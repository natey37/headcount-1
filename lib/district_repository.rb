require_relative 'district'
require_relative 'enrollment'
require_relative 'statewide_test_repository'
require_relative 'enrollment_repository'
require_relative 'economic_profile_repository'
require 'csv'
require 'pry'

class DistrictRepository
  attr_reader :districts
  def initialize()

  end

  def load_data(args)
    district = args[:enrollment][:kindergarten]

    enrollment_for_school = EnrollmentRepository.new
    enrollment_for_school.load_data(args)
    tests_for_school = StatewideTestRepository.new
    tests_for_school.load_data(args)
    economic_profiles_for_school = EconomicProfileRepository.new
    economic_profiles_for_school.load_data(args)

    @districts = []
      district_names(district).each do |name|
          testing = tests_for_school.find_by_name(name)
          enrollment = enrollment_for_school.find_by_name(name)
          economics = economic_profiles_for_school.find_by_name(name)
          districts << District.new({:name => name},
                                     enrollment,
                                     testing,
                                     economics)
       end
  end
  def collect_data(file)
    data = []
      CSV.foreach(file, :headers => true) do |row|
        data << row
      end
        return data
  end

  def district_names(file)
    collect_data(file).map{|row| row[0]}.uniq
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
