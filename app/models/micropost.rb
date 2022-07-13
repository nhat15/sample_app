class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  scope :last_posts, ->{order created_at: :desc}
  scope :by_user_id, ->(user_id){where user_id: user_id}
  delegate :name, to: :user, prefix: :user, allow_nil: true
  validates :content, presence: true, length: {maximum: Settings.micropost.content_max}
  validates :image, content_type: { in: Settings.micropost.image_path,
                                    message: :valid_image },
                                    size: { less_than: Settings.micropost.image_size.megabytes,
                                    message: :valid_image_size }

  def display_image
    image.variant resize_to_limit: Settings.micropost.resize_to_limit
  end
end
