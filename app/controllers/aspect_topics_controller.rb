class AspectTopicsController < ApplicationController
    before_action :signed_in_user, only: [:create, :destroy]
    before_action :correct_user, only: [:destroy]
    
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
        @topic.destroy
        redirect_to forum_path
    end
    
    private
        def aspect_topic_params
            params.require(:aspect_topic).permit(:content)
        end
        
        def correct_user
            @topic = current_user.aspect_topics.find_by(id: params[:id])
            redirect_to root_url if @topic.nil?
        end
end