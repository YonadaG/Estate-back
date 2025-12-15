require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  describe 'POST #signup' do
    context 'with valid params' do
      let(:user_params) { { user: attributes_for(:user).merge(password_confirmation: 'password123') } }

      it 'creates a user' do
        expect { post :signup, params: user_params }.to change(User, :count).by(1)
      end

      it 'sets session' do
        post :signup, params: user_params
        expect(session[:user_id]).to eq(User.last.id)
      end

      it 'returns created status' do
        post :signup, params: user_params
        expect(response).to have_http_status(:created)
      end

      it 'returns user data' do
        post :signup, params: user_params
        json = JSON.parse(response.body)
        expect(json['user']['email']).to eq(user_params[:user][:email])
        expect(json['message']).to eq('Signup successful')
      end
    end

    context 'password mismatch' do
      let(:user_params) { { user: attributes_for(:user).merge(password_confirmation: 'wrong') } }

      it 'does not create user' do
        expect { post :signup, params: user_params }.not_to change(User, :count)
      end

      it 'returns unprocessable_entity' do
        post :signup, params: user_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message' do
        post :signup, params: user_params
        json = JSON.parse(response.body)
        expect(json['errors']).to include('Password and password confirmation do not match')
      end
    end

    context 'invalid user data' do
      let(:user_params) { { user: attributes_for(:user, email: nil).merge(password_confirmation: 'password123') } }

      it 'does not create user' do
        expect { post :signup, params: user_params }.not_to change(User, :count)
      end

      it 'returns unprocessable_entity' do
        post :signup, params: user_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns validation errors' do
        post :signup, params: user_params
        json = JSON.parse(response.body)
        expect(json['errors']).to include("Email can't be blank")
      end
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }

    context 'with valid credentials' do
      let(:params) { { email: user.email, password: 'password123' } }

      it 'sets session' do
        post :create, params: params
        expect(session[:user_id]).to eq(user.id)
      end

      it 'returns user data' do
        post :create, params: params
        json = JSON.parse(response.body)
        expect(json['id']).to eq(user.id)
        expect(json['email']).to eq(user.email)
      end

      it 'returns ok status' do
        post :create, params: params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid credentials' do
      let(:params) { { email: user.email, password: 'wrong' } }

      it 'does not set session' do
        post :create, params: params
        expect(session[:user_id]).to be_nil
      end

      it 'returns unauthorized' do
        post :create, params: params
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error message' do
        post :create, params: params
        json = JSON.parse(response.body)
        expect(json['error']).to eq('Invalid email or password')
      end
    end

    context 'with non-existent email' do
      let(:params) { { email: 'nonexistent@example.com', password: 'password123' } }

      it 'returns unauthorized' do
        post :create, params: params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }

    before { session[:user_id] = user.id }

    it 'clears session' do
      delete :destroy
      expect(session[:user_id]).to be_nil
    end

    it 'returns success message' do
      delete :destroy
      json = JSON.parse(response.body)
      expect(json['message']).to eq('Logout successful')
    end

    it 'returns ok status' do
      delete :destroy
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #logged_in' do
    context 'when user is logged in' do
      let(:user) { create(:user) }

      before { session[:user_id] = user.id }

      it 'returns logged_in true' do
        get :logged_in
        json = JSON.parse(response.body)
        expect(json['logged_in']).to be_truthy
      end

      it 'returns user data' do
        get :logged_in
        json = JSON.parse(response.body)
        expect(json['user']['id']).to eq(user.id)
        expect(json['user']['email']).to eq(user.email)
      end

      it 'returns ok status' do
        get :logged_in
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not logged in' do
      it 'returns logged_in false' do
        get :logged_in
        json = JSON.parse(response.body)
        expect(json['logged_in']).to be_falsey
      end

      it 'does not return user data' do
        get :logged_in
        json = JSON.parse(response.body)
        expect(json).not_to have_key('user')
      end

      it 'returns ok status' do
        get :logged_in
        expect(response).to have_http_status(:ok)
      end
    end
  end
end