class Shape < ApplicationRecord
  belongs_to :user
  has_one :geospatial_datum
  validates :geometry, presence: true
end
