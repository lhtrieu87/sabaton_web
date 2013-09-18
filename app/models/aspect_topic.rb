class AspectTopic < ActiveRecord::Base
    has_many :comments, dependent: :destroy
    
    belongs_to :user
    default_scope -> {order('created_at DESC')}
    validates :user_id, presence: true
    validates :content, presence: true, length: {maximum: 250}
end
