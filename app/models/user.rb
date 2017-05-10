class User < ApplicationRecord
	has_many :posts, dependent: :destroy
	has_many :active_relationships, class_name: "Relationship",
	foreign_key: "follower_id",
	dependent: :destroy
	has_many :passive_relationships, class_name: "Relationship",
	foreign_key: "followed_id",
	dependent: :destroy
	has_many :following, through: :active_relationships, source: :followed
	has_many :followers, through: :passive_relationships, source: :follower
	
	before_save { self.email = email.downcase }
	validates :user_name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 },
	format: { with: VALID_EMAIL_REGEX },
	uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password, length: { minimum: 6 }, allow_blank: true


	# Returns a user's status feed.
	def feed
		following_ids = "SELECT followed_id FROM relationships
		WHERE follower_id = :user_id"
		Post.where("user_id IN (#{following_ids})
			OR user_id = :user_id", user_id: id)
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

	# Returns true if the current user is following the other user.
	def following?(other_user)
		following.include?(other_user)
	end
end
