class AspectTopicsController < ApplicationController
    before_action :signed_in_user, only: [:create, :destroy]
    
    def create
        @topic = current_user.aspect_topics.build(aspect_topic_params)
        if @topic.save
            flash[:success] = "A new topic has been created!"
            redirect_to forum_path
        else
            p @topic.errors.count
            render 'static_pages/forum'
        end
    end
    
    def destroy
        
    end
    
    private
        def aspect_topic_params
            params.require(:aspect_topic).permit(:content)
        end
end