class Movie < ActiveRecord::Base
  
  def self.unique_ratings
    ratings = Set.new
    Movie.all.each { |m| ratings << m.rating }
    return ratings
  end

  def self.sorted(field)
    find(:all, :order => "#{field} asc")
  end



end
