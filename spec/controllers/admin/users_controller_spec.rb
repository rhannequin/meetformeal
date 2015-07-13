require 'rails_helper'

describe Admin::UsersController, type: :controller do
  describe 'GET #index' do
    let(:user) { create :user }

    before(:each) { sign_in user }

    it 'responds successfully with an HTTP 200 status code' do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end

    it 'loads all of the users into @users' do
      user1, user2 = create(:user), create(:user)
      get :index
      expect(assigns(:users)).to match_array([user, user1, user2])
    end
  end
end