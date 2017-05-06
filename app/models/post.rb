class Post < ApplicationRecord
	belongs_to :user
	default_scope -> { order(created_at: :desc) }
	mount_uploader :picture, PictureUploader

	validates :user_id, presence: true
	validates :content, presence: true, length: { maximum: 140 }
	validate :picture_size
       has_attached_file :image, styles: { large:"600x600>",medium: "400x400>", thumb: "100x100#" }
       validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

	private
	# Validates the size of an uploaded picture.
	def picture_size
		if picture.size > 5.megabytes
			errors.add(:picture, "should be less than 5MB")
		end
	end
end
