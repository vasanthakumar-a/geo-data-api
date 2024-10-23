class GeospatialDatum < ApplicationRecord
  belongs_to :user
  has_one_attached :file, dependent: :destroy
  belongs_to :shape
  validates :name, presence: true

  before_save :ensure_unique_name

  private
  def ensure_unique_name
    base_name = self.name
    counter = 1
    while GeospatialDatum.exists?(name: self.name)
      self.name = "#{base_name}_#{counter}"
      counter += 1
    end
  end
end
