# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  comments_count         :integer          default(0)
#  email                  :citext           default(""), not null
#  encrypted_password     :string           default(""), not null
#  likes_count            :integer          default(0)
#  photo_count            :integer
#  private                :boolean          default(TRUE)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :citext
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :own_photos, foreign_key: "owner_id", class_name: "Photo"
  has_many :comments, foreign_key: "author_id"
  has_many :sent_follow_requests, foreign_key: :sender_id, class_name: "FollowRequest"
  has_many :accepted_sent_follow_requests, -> { accepted }, foreign_key: :sender_id, class_name: "FollowRequest"
  has_many :received_follow_requests, foreign_key: :recipient_id, class_name: "FollowRequest"
  has_many :accepted_received_follow_requests, -> { accepted }, foreign_key: :sender_id, class_name: "FollowRequest"
  has_many :likes, foreign_key: :fan_id
  has_many :liked_photos, through: :likes, source: :photo
  has_many :leaders, through: :accepted_sent_follow_requests, source: :recipient

  has_many :followers, through: :accepted_received_follow_requests, source: :sender

  has_many :feed, through: :leaders, source: :own_photos
  has_many :discover, through: :leaders, source: :liked_photos

  validates :username, presence: true, uniqueness: true

  scope :past_week, -> { where(created_at: 1.week.ago...) }

  scope :by_likes, -> { order(likes_count: :desc) }
end
