class Shape < ApplicationRecord
  belongs_to :user
  has_one :geospatial_datum
  validates :geometry, presence: true

  before_save :ensure_unique_name

  def self.kml_to_wkt(kml_data)
    doc = Nokogiri::XML(kml_data)
    kml_ns = { "kml" => "http://www.opengis.net/kml/2.2" }
    kml_coordinates = []

    doc.xpath('//kml:Placemark', kml_ns).each do |placemark|
      point = placemark.at_xpath('kml:Point/kml:coordinates', kml_ns)
      line = placemark.at_xpath('kml:LineString/kml:coordinates', kml_ns)
      polygon = placemark.at_xpath('kml:Polygon/kml:outerBoundaryIs/kml:LinearRing/kml:coordinates', kml_ns)
      kml_coordinate = ''

      if point
        coordinates = Shape.convert_to_coordinates(point.text.strip)
        kml_coordinate = "POINT #{coordinates.join(', ')}"
      elsif line
        coordinates = Shape.convert_to_coordinates(line.text.strip)
        kml_coordinate = "LINESTRING (#{coordinates.join(', ')})"
      elsif polygon
        coordinates = Shape.convert_to_coordinates(polygon.text.strip)
        kml_coordinate = "POLYGON (#{coordinates.join(', ')})"
      end
      kml_coordinates << kml_coordinate
    end
    kml_coordinates[0]
  end

  def self.convert_to_coordinates(coordinate_string)
    coordinates = coordinate_string.split("\n").map(&:strip)
    coordinates.map do |coord|
      lon, lat, _altitude = coord.split(',')
      "(#{lon} #{lat})"
    end
  end

  private
  def ensure_unique_name
    base_name = self.name
    counter = 1
    while Shape.exists?(name: self.name)
      self.name = "#{base_name}_#{counter}"
      counter += 1
    end
  end
end
