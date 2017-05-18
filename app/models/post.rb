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
	validates_processing_of :picture
 
validate :image_size_validation
 
   
  def image_size_validation
    errors[:picture] << "should be less than 500KB" if picture.size > 0.5.megabytes
  end

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
	
	
	
end
