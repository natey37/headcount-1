require_relative 'district'
require_relative 'enrollment'
require 'csv'
require 'pry'

class DistrictRepository
  attr_reader :districts, :district, :highschool_graduation
  def initialize()

  end

  def load_data(args)
    @district = args[:enrollment][:kindergarten]
    @highschool_graduation = args[:enrollment][:high_school_graduation]
    @districts = []
    ke = kindergarten_enrollment
    hg = highschool_graduation_rate
      district_names(district).each do |name|
          districts << District.new({:name => name},
                         Enrollment.new(:name => name,
                         :kindergarten_participation => ke[name],
                         :high_school_graduation => hg[name]))
       end
  end
  def collect_data(file)
    data = []
      CSV.foreach(file, :headers => true) do |row|
        data << row
      end
        return data
  end

  def highschool_graduation_rate
    making_hash_of_data(highschool_graduation)
  end

  def district_names(file)
    collect_data(file).map{|row| row[0]}.uniq
  end

  def kindergarten_enrollment
    making_hash_of_data(district)
  end

  def district_names_as_hash_keys(file)
    names = {}
    district_names(file).each{|name| names[name] = {}}
      return names
  end

  def making_hash_of_data(file)
      names_with_stats = district_names_as_hash_keys(file)
      collect_data(file).each do |row|
        names_with_stats[row[0]].store(row[1].to_i, row[3].to_f)
      end
        return names_with_stats
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
