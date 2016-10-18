class Movie < ActiveRecord::Base
    def self.get_ratings
        return Movie.uniq.pluck(:rating)
    end
end
