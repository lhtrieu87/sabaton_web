class UsersController < ApplicationController
    before_action :signed_in_user, only: [:edit, :update]
    before_action :correct_user,   only: [:edit, :update]
    
    def new
        @user = User.new
    end
    
    # def show
        # @user = User.find(params[:id])
        # @topics = @user.aspect_topics.paginate(page: params[:page], per_page: 10)        
    # end
    
    def create
        @user = User.new(user_params)    # Not the final implementation!
        if @user.save
            sign_in @user
            flash[:success] = "Welcome to the Sabaton Studio"
            redirect_to root_url
        else
            render 'new'
        end
    end
    
    def edit
    end
    
    def update
        if @user.update_attributes(user_params)
            flash[:success] = "Profile updated";
            sign_in @user
            redirect_to root_url
        else
            render 'edit'
        end
    end
    
    # Use strong parameters to prevent mass assignment vulnerability.
    private
        def user_params
            params.require(:user).permit(:name, :email, :password,
                                         :password_confirmation)
        end
        
        def correct_user
            @user = User.find(params[:id])
            redirect_to root_url, notice: "You are wrong user to access this protected page!!! So naughty!!!" unless current_user?(@user)
        end
end
