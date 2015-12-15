require 'rails_helper'

feature 'User edit registration' do
  describe 'from regular user' do
    let(:user) { create(:user) }

    background do
      login_with(user)
      visit root_path
      click_link I18n.t(:'layouts.navbar.account.settings')
    end

    scenario 'a user can see the edit registration form' do
      within 'form#edit_user' do
        expect(page).to have_field I18n.t(:'simple_form.labels.user.email')
        expect(page).to have_field I18n.t(:'simple_form.labels.user.password')
        expect(page).to have_field I18n.t(:'simple_form.labels.user.password_confirmation')
        expect(page).to have_field I18n.t(:'simple_form.labels.user.current_password')
        expect(page).to have_button I18n.t(:'devise.registrations.form.update')
      end
    end

    describe 'when a user changes personal information' do
      let(:new_name) { build(:user).name }

      background do
        within 'form#edit_user' do
          fill_in I18n.t(:'simple_form.labels.user.name'), with: new_name
          fill_in I18n.t(:'simple_form.labels.user.email'), with: 'new.email@example.com'
          fill_in I18n.t(:'simple_form.labels.user.password'), with: 'new password'
          fill_in I18n.t(:'simple_form.labels.user.password_confirmation'), with: 'new password'
          find('#user_current_password').set 'password'
          click_button I18n.t(:'devise.registrations.form.update')
        end
      end

      scenario 'his information are updated' do
        expect(current_path).to eq(root_path)
        expect(page).to have_content new_name
        expect(page).to have_content I18n.t(:'devise.registrations.updated')
      end
    end
  end

  %w(twitter facebook).each do |provider|
    describe "when signed in with #{provider.capitalize}" do
      background do
        send :"mock_auth_#{provider}"
        visit user_omniauth_authorize_path(provider: provider)
        visit edit_user_registration_path
      end

      scenario "can't edit his credentials" do
        expect(page).not_to have_css 'form#edit_user'
      end

      scenario 'sees his username' do
        expect(page).to have_content "#{provider.capitalize} User" # See Macros::Omniauth
      end
    end
  end
end
