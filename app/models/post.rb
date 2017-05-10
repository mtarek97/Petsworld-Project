class Post < ApplicationRecord
	has_many :comments, as: :commentable , dependent: :destroy
	has_many :taggings ,:dependent => :destroy
	has_many :tags,through: :taggings

	belongs_to :user
	default_scope -> { order(created_at: :desc) }
	mount_uploader :picture, PictureUploader

	validates_presence_of :all_tags
	validates :user_id, presence: true
	validates :content, presence: true, length: { maximum: 140 }
	validate :picture_size
	has_attached_file :image, styles: { large:"600x600>",medium: "400x400>", thumb: "100x100#" }
	validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

	act_as_likee

	def all_tags=(names)
		self.tags = names.split(",").map do |name|
			Tag.where(name: name.strip).first_or_create!
		end
	end

	#generate an array of tags for post
	def all_tags
		self.tags.map(&:name).join(", ")
	end

	#return posts with specific tag name
	def self.tagged_with(name)
		Tag.find_by_name!(name).posts
	end
	
	private
	# Validates the size of an uploaded picture.
	def picture_size
		if picture.size > 5.megabytes
			errors.add(:picture, "should be less than 5MB")
		end
	end
end
