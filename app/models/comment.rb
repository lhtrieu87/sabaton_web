class Comment < ActiveRecord::Base
    belongs_to :user
    belongs_to :aspect_topic
    
    default_scope -> {order('created_at DESC')}
    
    validates :user_id, presence: true
    validates :aspect_topic_id, presence: true
    validates :content, presence: true, length: {maximum: 250}
end
