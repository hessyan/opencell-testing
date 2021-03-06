class Plate < ApplicationRecord

  extend QrModule

  has_many :wells, dependent: :destroy
  has_many :samples, dependent: :nullify
  has_one :test, dependent: :destroy
  accepts_nested_attributes_for :wells
  enum state: %i[preparing prepared testing complete]
  validates :wells, length: {maximum: 96, minimum: 96}
  qr_for :uid

  before_create :set_uid
  scope :is_preparing, -> {where(state: Plate.states[:preparing])}
  scope :is_prepared, -> {where(state: Plate.states[:prepared])}
  scope :is_testing, -> {where(state: Plate.states[:testing])}
  scope :is_complete, -> {where(state: Plate.states[:complete])}


  def set_uid
    self.uid = SecureRandom.uuid
  end


  def to_csv
    headers = %w{plate_id well_id well_row well_col sample_in_well}
    CSV.generate(headers: true) do |csv|
      csv << headers
      wells.each do |well|
        csv << [well.plate_id, well.id, well.row, well.column, !well.sample.nil?]
      end
    end
  end

end

module PlateHelper
  @@rows = ('A'..'H')
  @@columns = (1..12)

  def self.columns
    @@columns
  end

  def self.rows
    @@rows
  end
end