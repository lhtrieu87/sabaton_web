class CommentsController < ApplicationController
    before_action :signed_in_user, only: [:create, :destroy]
    def create
        @comment = current_user.comments.build(comment_params)

        respond_to do |format|
            if @comment.save
                format.js {render json: [{
                                 'aspect_topic_id' => @comment.aspect_topic_id,
                                            'html' => render_to_string(:action => "create", :layout => false)
                                        }]
                }
            else
            end
        end
    end

    def destroy
    end

    private

    def comment_params
        params.require(:comment).permit(:content, :aspect_topic_id)
    end
end
