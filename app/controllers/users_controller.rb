class UsersController < ApplicationController
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
            # Handle a successful update.
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
end
