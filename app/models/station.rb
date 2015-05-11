class Station < ActiveRecord::Base
  belongs_to :forecast
  validates :lat, uniqueness: true
  validates :lng, uniqueness: true
  # validate :proximity

  def proximity
    if close_latlng(0.004)
      self.errors.add(:lat, "Too close to another station")
      self.errors.add(:lng, "Too close to another station")
    end
  end

  def close_latlng(prox)
    bool_array = Station.all.each.map do |station|
      station.lat.between?(self.lat - prox, self.lat + prox) || station.lng.between?(self.lng - prox, self.lng + prox)
    end
    !bool_array.include?(true)
  end

end
