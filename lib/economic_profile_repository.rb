require 'csv'
require 'pry'
require_relative 'district_repository'
require_relative 'economic_profile'

class EconomicProfileRepository
  attr_reader :economic_profiles

  def load_data(args)
    median_household_income = args[:economic_profile][:median_household_income]
    children_in_poverty = args[:economic_profile][:children_in_poverty]
    free_or_reduced_price_lunch = args[:economic_profile][:free_or_reduced_price_lunch]
    title_i = args[:economic_profile][:title_i]

    mhi = median_household_income_info(median_household_income)
    cipi = children_in_poverty_info(children_in_poverty)
    forpli = free_or_reduced_price_lunch_info(free_or_reduced_price_lunch)
    tii = title_i_info(title_i)


    @economic_profiles = []
      district_names(median_household_income).each do |district|
        economic_profiles << EconomicProfile.new({
                              :median_household_income => mhi[district],
                              :children_in_poverty => cipi[district],
                              :free_or_reduced_price_lunch => forpli[district],
                              :title_i => tii[district],
                              :name => district
                             })
     end

       return economic_profiles
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

  def district_names_as_hash_keys(file)
    names = {}
    district_names(file).each{|name| names[name] = {}}
      return names
  end

  def median_household_income_info(file)
      names_with_stats = district_names_as_hash_keys(file)
      collect_data(file).each do |row|
        names_with_stats[row[0]].store(row[1].split(/-/).map{|x|x.to_i}, row[3].to_f)
      end
        return names_with_stats
  end

  def children_in_poverty_info(file)
      names_with_stats = district_names_as_hash_keys(file)
      collect_data(file).each do |row|
        names_with_stats[row[0]].store(row[1].to_i, row[3].to_f)
      end
        return names_with_stats
  end

  def free_or_reduced_price_lunch_info(file)
    names_with_stats = district_names_as_hash_keys(file)
    names_with_stats1 = district_names_as_hash_keys(file)
    collect_data(file).each do |row|
      if row[1] == "Eligible for Free or Reduced Lunch" && row[3] == "Percent"
        names_with_stats[row[0]].store(row[2].to_i, {:percentage => row[4].to_f.round(3)} )
      elsif row[1] == "Eligible for Free or Reduced Lunch" && row[3] == "Number"
        names_with_stats1[row[0]].store(row[2].to_i, {:total => row[4].to_i} )
      end
    end
      return final = deep_merge(names_with_stats, names_with_stats1)
  end

  def title_i_info(file)
    names_with_stats = district_names_as_hash_keys(file)
    collect_data(file).each do |row|
      names_with_stats[row[0]].store(row[1].to_i, row[3].to_f.round(3))
    end
      return names_with_stats
  end

  def deep_merge(h1, h2)
    h1.merge(h2) { |key, h1_elem, h2_elem| deep_merge(h1_elem, h2_elem) }
  end

  def find_by_name(name)
    economic_profiles.each do |ep|
      return ep if ep.name.upcase == name.upcase
    end
  end

end
