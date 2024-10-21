class GeospatialDatum < ApplicationRecord
  belongs_to :user
  has_one_attached :file
  belongs_to :shape
  validates :name, presence: true
end
