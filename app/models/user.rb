class User < ActiveRecord::Base
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  before_save { self.email = email.downcase }
  # before_save { self.email = self.email.downcase }  # same as above
  # We can omit the 2nd self because Rails does this for us.

  mount_uploader :image, ImageUploader
  # mount_uploader :image, AssetUploader
  # after_save :enqueue

  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications

  has_one :garden
  has_many :products, through: :garden
  has_many :messages, through: :product
  has_many :trades

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes["password"] }
  validates :password, confirmation: true, if: -> { new_record? || changes["password"] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes["password"] }

  validates :email, presence: true
  validates :email, uniqueness: {case_sensitive: false}
  validates :email, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
    message: "not a valid email address" }
  validates :name, presence: true

end
