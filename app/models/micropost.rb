class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  # Makes CarrierWave associate the picture to the model
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence:true, length: { maximum: 140 }
  # Custom validations use 'validate' (singular not plural). Rails doesn't
  # have a validaiton for this, so here is a custom one.
  validate :picture_size


  private

    # Validates the size of an uploaded picture
    def picture_size
      if picture.size > 5.megabytes
        error.add(:picture, "should be less then 5MB")
      end
    end
end
