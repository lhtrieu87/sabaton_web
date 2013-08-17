module SessionsHelper
    def sign_in(user)
        # Create a new token and add it into the response.
        remember_token = User.new_remember_token
        cookies.permanent[:remember_token] = remember_token
        # Persist the encrypted token into the db.
        user.update_attribute(:remember_token, User.encrypt(remember_token))
        # The page knows who is the current user now.
        self.current_user = user
    end
    
    def signed_in?
        !current_user.nil?        
    end

    def current_user=(user)
        @current_user = user
    end
    
    # Verify whether user signed in.
    def current_user
        remember_token = User.encrypt(cookies[:remember_token])
        @current_user ||= User.find_by(remember_token: remember_token)
    end
    
    def sign_out
        self.current_user = nil
        cookies.delete :remember_token
    end
end
