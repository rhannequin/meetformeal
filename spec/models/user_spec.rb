require 'rails_helper'

describe User, type: :model do
  let(:user) { create :user }

  describe 'email' do
    it 'must be unique' do
      email = 'unique@email.com'
      create :user, email: email
      expect(build(:user, email: email)).not_to be_valid
    end
  end

  describe 'passwords' do
    it 'has a password attribute' do
      expect(user).to respond_to(:password)
    end

    it 'has a password confirmation attribute' do
      expect(user).to respond_to(:password_confirmation)
    end
  end

  describe 'password validations' do
    it 'requires a password' do
      expect(build(:user, password: '', password_confirmation: ''))
        .not_to be_valid
    end

    it 'requires a matching password confirmation' do
      expect(build(:user, password_confirmation: 'invalid')).not_to be_valid
    end

    it 'rejects short passwords' do
      short = 'a' * 5
      expect(build(:user, password: short, password_confirmation: short))
        .not_to be_valid
    end
  end

  describe 'password encryption' do
    it 'has an encrypted password attribute' do
      expect(user).to respond_to(:encrypted_password)
    end

    it 'sets the encrypted password attribute' do
      expect(user.encrypted_password).not_to be_blank
    end
  end
end
