require 'rails_helper'

describe 'layouts/_header.html.erb' do
  describe 'general information' do
    it "shows application name and root path link" do
      allow(view).to receive_messages(current_user: nil)
      render
      expect(rendered).to include(I18n.t(:'layouts.application_name'))
      expect(rendered).to include(I18n.t(:'layouts.navbar.home'))
      expect(rendered).to include(root_path)
    end
  end

  describe 'header links' do
    describe 'when not connected' do
      before(:each) { allow(view).to receive_messages(current_user: nil) }

      it 'has sign in and sign up links' do
        render
        expect(rendered).to include(I18n.t(:'devise.sessions.new.sign_in'))
        expect(rendered).to include(I18n.t(:'devise.registrations.new.sign_up'))
      end

      it 'does not have sign out link' do
        render
        expect(rendered).not_to include(I18n.t(:'devise.sessions.destroy.sign_out'))
      end
    end

    describe 'when connected' do
      before(:each) { sign_in create :user }

      it 'has sign out link' do
        render
        expect(rendered).to include(I18n.t(:'devise.sessions.destroy.sign_out'))
      end

      it 'does not have sign in nor sign up links' do
        render
        expect(rendered).not_to include(I18n.t(:'devise.sessions.new.sign_in'))
        expect(rendered).not_to include(I18n.t(:'devise.registrations.new.sign_up'))
      end

      describe 'as a regular user' do
        it 'does not have admin link' do
          render
          expect(rendered).not_to include(I18n.t(:'layouts.navbar.admin.name'))
        end
      end

      describe 'as an admin' do
        it 'has admin links' do
          sign_in create :admin
          render
          expect(rendered).to include(I18n.t(:'layouts.navbar.admin.name'))
          expect(rendered).to include(I18n.t(:'layouts.navbar.admin.users'))
        end
      end
    end
  end
end
