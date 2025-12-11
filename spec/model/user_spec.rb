require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'is invalid without a name' do
      user = build(:user, name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without an email' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end
    it 'is invalid without a phone' do
      user = build(:user, phone: nil)
      expect(user).not_to be_valid
      expect(user.errors[:phone]).to include("can't be blank")
    end

    it 'is invalid with a duplicate email' do
      create(:user, email: 'test@email.com')
      user = build(:user, email: 'test@email.com')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('has already been taken')
    end

    it 'is invalid with invalid role' do
      user = build(:user, role: 'invalid_role')
      expect(user).not_to be_valid
      expect(user.errors[:role]).to include('is not included in the list')
    end

    it 'is valid with correct roles' do
      %w[admin broker owner user].each do |role|
        user = build(:user, role:)
        expect(user).to be_valid
      end
    end
  end

  describe 'password' do
    it 'is invalid with short password' do
      user = build(:user, password: '123')
      expect(user).not_to be_valid
      puts "User errors: #{user.errors.full_messages}"
      expect(user.errors[:password]).to include('is too short (minimum is 6 characters)')
    end
  end

  describe 'roles method' do
    it 'returns correct roles' do
      user = build(:user, role: 'user')
      expect(user.user?).to be true
      expect(user.admin?).to be false
      expect(user.broker?).to be false
      expect(user.owner?).to be false
    end

    it 'checks permission to create property' do
      seeker = build(:user, role: 'seeker')
      owner = build(:user, role: 'owner')
      broker = build(:user, role: 'broker')

      expect(seeker.can_create_property?).to be false
      expect(owner.can_create_property?).to be true
      expect(broker.can_create_property?).to be true
    end
  end
end