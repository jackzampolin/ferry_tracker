class Station < ActiveRecord::Base
  belongs_to :forecast
  validates :lat, uniqueness: true
  validates :lng, uniqueness: true
end
