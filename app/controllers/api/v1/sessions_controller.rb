module Api
  module V1

 class SessionsController < ApplicationController
    # POST /signup
    def signup
        if signup_params[:password] != signup_params[:password_confirmation]
            render json: {
                errors: [ "Password and password confirmation do not match" ]
            }, status: :unprocessable_entity
        end
        
        user = User.new(signup_params.except(:password_confirmation))
        if user.save
            session[:user_id] = user.id
            render json: {
                user: serialize_user(user),
                message: "Signup successful"
            }, status: :created
        else
            render json: {
                errors: user.errors.full_messages
            }, status: :unprocessable_entity
        end
    end
    # POST /Login
    def create
        creds = session_params
        user = User.find_by(email: creds[:email])

        if user&.authenticate(creds[:password])
            session[:user_id] = user.id
            render json: user
        else
            render json: { error: "Invalid email or password" }, status: :unauthorized
        end
    end

    # DELETE /logout
    def destroy
        session[:user_id]= nil
        render json: {
            message: "Logout successful"
        }
    end

    def logged_in
        if current_user
            render json: {
                logged_in: true,
                user: serialize_user(current_user) 
            }
        else
            render json: {
                logged_in: false
            }
        end
    end

    private

    def signup_params
        params.require(:user).permit(
            %i[name email password password_confirmation phone role]
        )
    end

    def session_params
        params.permit(:email, :password)
    end

    def serialize_user(user)
        {
            id: user.id,
            name: user.name,
            email: user.email,
            phone: user.phone,
            role: user.role
        }
    end
 end
  end
end
