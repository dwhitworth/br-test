class Area < ActiveRecord::Base
  include FriendlyId
  friendly_id :display_name, :use => :slugged
  validates_presence_of :display_name, :slug

  has_many :videos
  has_many :places

  has_many :photos
  accepts_nested_attributes_for :photos

  validates :display_name, uniqueness: { case_sensitive: false }, presence: true


  def Area.all_geojson
    geojson = {"type" => "FeatureCollection","features" => []}

    areas = Area.all
    areas.each do |area|
      next if area.published_status == ('draft' || 'out')
      geojson['features'] << {
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: [area.longitude, area.latitude]
        },
        properties: {
          "title"=> area.display_name,
          "url" => '/areas/' + area.slug + '.html',
          "id" => area.id,
          "places" => !area.places.where(subscription_level: ['Premium', 'standard', 'basic']).empty?,
          "icon" => {
            "iconUrl" => 'https://s3.amazonaws.com/donovan-bucket/orange_plane.png',
            # size of the icon
            "iconSize" => [43, 26],
            # point of the icon which will correspond to marker location
            "iconAnchor" => [20, 0]
          }
        }
      }
    end

    return geojson
  end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]
    Area.create!(row.to_h)
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when '.csv' then Csv.new(file.path, nil, :ignore)
      when '.xls' then Roo::Excel.new(file.path, nil, :ignore)
      when '.xlsx' then Roo::Excelx.new(file.path, nil, :ignore)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end

end
