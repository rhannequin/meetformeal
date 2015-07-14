require 'rails_helper'

describe Admin::UsersController, type: :controller do
  describe 'GET #index' do
    let(:user) { create :admin }

    before(:each) { sign_in user }

    it "can't access if not authorized" do
      sign_in create(:user)
      get :index
      expect(response).not_to be_success
      expect(response).not_to have_http_status(200)
    end

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

  describe 'GET #show' do
    let(:user) { create :admin }
    let(:user_showed) { create :user }

    before(:each) { sign_in user }

    it "can't access if not authorized" do
      sign_in create(:user)
      get :show, id: user_showed.id
      expect(response).not_to be_success
      expect(response).not_to have_http_status(200)
    end

    it 'responds successfully with an HTTP 200 status code' do
      get :show, id: user_showed.id
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'renders the show template' do
      get :show, id: user_showed.id
      expect(response).to render_template('show')
    end

    it 'loads the user into @user' do
      get :show, id: user_showed.id
      expect(assigns(:user)).to eq(user_showed)
    end
  end
end