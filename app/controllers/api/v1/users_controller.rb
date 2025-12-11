module Api
  module V1

class UsersController < ApplicationController
 skip_before_action :require_login, only: [:create]
    def create
        @user = User. new(user_params)
        if @user.save
          render json: { user: @user, message:'User created successful'},
          status: :created
        else
        render json: { errors: @user.errors.full_messages },
        status: :unprocessable_entity
        end
    end

    def show
        @user = User.find(params[:id])
        render json: @user
    end

    def update
        @user = User.find(params[:id])

        if @user == current_user && @user.update(user_params)
            render json: {user: @user, message: 'User updated successfully'}
        else
            render json: { errors: @user.errors.full_messages },
            status: :unprocessable_entity
        end
    end

     private

     def user_params
        params.require(:user).permit(:name, :email,:phone,:role ,:password)
     end
end 
  end
end
