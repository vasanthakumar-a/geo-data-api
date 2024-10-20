class Shape < ApplicationRecord
  belongs_to :user
  validates :geometry, presence: true
end
