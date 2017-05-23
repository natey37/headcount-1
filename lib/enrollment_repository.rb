require './lib/enrollment.rb'
require 'csv'

class EnrollmentRepository

  attr_reader :enrollment

  def initialize

  end

  def load_data(hash)
    file_name = hash[:enrollment][:kindergarten]
    data = []
      CSV.foreach(file_name, :headers => true) do |row|
        data << row
      end

    names = data.map{|row| row[0]}.uniq
    enroll = {}
      names.each do |name|
        enroll[name] = {}
      end
      data.each do |row|
        enroll[row[0]].store(row[1].to_i, row[3].to_f)
      end
    @enrollment = []
    enroll.each do |district, attendance_hash|
      enrollment << Enrollment.new(district, attendance_hash)
    end



  end

  def find_by_name(name)
    enrollment.each do |e|
      return e if e.name.upcase == name.upcase
    end
  end
end
