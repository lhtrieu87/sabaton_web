class UsersController < ApplicationController
    before_action :signed_in_user, only: [:edit, :update]
    
    def new
        @user = User.new
    end
    
    def show
        @user = User.find(params[:id])        
    end
    
    def create
        @user = User.new(user_params)    # Not the final implementation!
        if @user.save
            sign_in @user
            flash[:success] = "Welcome to the Sabaton Studio"
            redirect_to @user
        else
            render 'new'
        end
    end
    
    def edit
        @user = User.find(params[:id])
    end
    
    def update
        @user = User.find(params[:id])
        if @user.update_attributes(user_params)
            flash[:success] = "Profile updated";
            sign_in @user
            redirect_to @user
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
        
        
        # Before filters
        def signed_in_user
            redirect_to signin_url, notice: "Please sign in!!! Do not be naughty!!!" unless signed_in?
        end
end
