class CommentsController < ApplicationController
    before_action :signed_in_user, only: [:create, :destroy]
    
    def create
        @comment = current_user.comments.build(comment_params)
        @comment.save
        respond_to do |format|
            format.js
        end
    end

    def destroy
    end

    private

    def comment_params
        params.require(:comment).permit(:content, :aspect_topic_id)
    end
end
