class GeospatialDatum < ApplicationRecord
  belongs_to :user
  has_one_attached :file
  validates :name, presence: true
  validates :geometry, presence: true
end
