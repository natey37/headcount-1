class UnknownDataError < StandardError
end

class EconomicProfile
  attr_reader :median_household_income, :children_in_poverty,
              :free_or_reduced_price_lunch, :title_i, :name
  def initialize(args)
    @median_household_income = args[:median_household_income]
    @children_in_poverty = args[:children_in_poverty]
    @free_or_reduced_price_lunch = args[:free_or_reduced_price_lunch]
    @title_i = args[:title_i]
    @name = args[:name]
  end

  def median_household_income_in_year(year)
    incomes = []
    median_household_income.each do |years, income|
      if year >= years[0] && year <= years[1]
        incomes << income
      end
    end
      raise UnknownDataError if incomes.empty?
        return  incomes.reduce(:+) / incomes.count
  end

  def median_household_income_average
    incomes = []
    median_household_income.each do |years, income|
      incomes << income
    end
      return incomes.reduce(:+) / incomes.count
  end

  def children_in_poverty_in_year(year)
    raise UnknownDataError if children_in_poverty[year] == nil
      return children_in_poverty[year]
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    raise UnknownDataError if free_or_reduced_price_lunch[year] == nil
      return free_or_reduced_price_lunch[year][:percentage]
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    raise UnknownDataError if free_or_reduced_price_lunch[year] == nil
      return free_or_reduced_price_lunch[year][:total]
  end

  def title_i_in_year(year)
    raise UnknownDataError if title_i[year] == nil
      return title_i[year]
  end
end
