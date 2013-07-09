class SessionsController < ApplicationController
    def new
    end

    def create
        user = User.find_by_email(params[:session][:email].downcase)
        if user && user.authenticate(params[:session][:password] )
            #sign in the user and redirect to yhe user's show page.
            sign_in user
            #redirect_to user
            #new redirect to forward to page user attempted to visit
            redirect_back_or user
        else
            #create an error message and re-render the signin form
            flash.now[:error] = 'Invalid email/password combination'
            render 'new'
        end
    end

    def destroy
        sign_out
        redirect_to root_url
    end
end
