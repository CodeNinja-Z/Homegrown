class Product < ActiveRecord::Base
  has_many :conversations
  belongs_to :garden
  belongs_to :trade
  validates :name, presence: true
  acts_as_taggable
  geocoded_by :postal_code
  after_validation :geocode
  

  # Carrierwave_background and Delayed jobs
  mount_uploader :image, ImageUploader
  # process_in_background :image
  # store_in_background :image
  


  def self.find_by_tag(tag)
    Product.joins(:tags).where('tags.name LIKE ?', "%#{tag}%")
  end

end
