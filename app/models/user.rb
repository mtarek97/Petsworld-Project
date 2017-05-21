class User < ApplicationRecord
	has_many :notifications, dependent: :destroy  
	has_many :comments, dependent: :destroy
	has_many :posts, dependent: :destroy
	has_many :active_relationships, class_name: "Relationship",
	foreign_key: "follower_id",
	dependent: :destroy
	has_many :passive_relationships, class_name: "Relationship",
	foreign_key: "followed_id",
	dependent: :destroy
	mount_uploader :picture, ImageUploader
	has_many :following, through: :active_relationships, source: :followed
	has_many :followers, through: :passive_relationships, source: :follower
	before_create :confirmation_token
	before_save { self.email = email.downcase }
	validates :user_name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 },
	format: { with: VALID_EMAIL_REGEX },
	uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password, length: { minimum: 6 }, allow_blank: true
	act_as_liker
	validates_processing_of :picture
	
	validate :image_size_validation
	
	
	def image_size_validation
		errors[:picture] << "should be less than 500KB" if picture.size > 0.5.megabytes
	end

	# Returns a user's status feed.
	def feed
		following_ids = "SELECT followed_id FROM relationships
		WHERE follower_id = :user_id"
		Post.where("user_id IN (#{following_ids})
			OR user_id = :user_id", user_id: id)
	end
	def email_activate
		self.email_confirm =true
		self.confirm_token =nil
		save!(:validates => false)
	end
	def self.search(search)
		where("user_name LIKE ?", "%#{search}%") 
	end


	# Follows a user.
	def follow(other_user)
		active_relationships.create(followed_id: other_user.id)
	end

	# Unfollows a user.
	def unfollow(other_user)
		active_relationships.find_by(followed_id: other_user.id).destroy
	end
	def confirmation_token
		if self.confirm_token.blank?
			self.confirm_token = SecureRandom .urlsafe_base64.to_s
		end
	end
	# Returns true if the current user is following the other user.
	def following?(other_user)
		following.include?(other_user)
	end
end
