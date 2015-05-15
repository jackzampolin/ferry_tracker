class Station < ActiveRecord::Base
  belongs_to :forecast
  # validates :pws_id, uniqueness: true
end
