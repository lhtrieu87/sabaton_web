module SessionsHelper
    def sign_in(user)
        # Create a new token and add it into the response.
        remember_token = User.new_remember_token
        cookies.permanent[:remember_token] = remember_token
        # Persist the encrypted token into the db.
        user.update_attribute(:remember_token, User.encrypt(remember_token))
        # The page knows who is the current user now.
        current_user = user
    end

    def signed_in?
        !current_user.nil?
    end
    
    def signed_in_user
        unless signed_in?
            store_location
            redirect_to signin_url, notice: "Please sign in!!! Do not be naughty!!!"
        end
    end

    def current_user=(user)
        @current_user = user
    end

    def current_user?(user)
        user == current_user
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

    def redirect_back_or(default)
        # redirect_to(session[:return_to] || default)
        redirect_to root_url
        session.delete(:return_to)
    end

    def store_location
        session[:return_to] = request.url
    end
end
