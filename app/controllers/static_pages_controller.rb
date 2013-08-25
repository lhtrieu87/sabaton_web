class StaticPagesController < ApplicationController
    def home
    end
    
    def about
    end
    
    def forum
        @current_user = current_user
        @topic = @current_user.aspect_topics.build() if signed_in?
    end
end
