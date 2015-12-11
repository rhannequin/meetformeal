require 'rails_helper'

feature 'User edit registration' do
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
      expect(page).to have_button I18n.t(:'devise.registrations.edit.update')
    end
  end

  describe 'when a user changes personal information' do
    background do
      within 'form#edit_user' do
        fill_in I18n.t(:'simple_form.labels.user.email'), with: 'new.email@example.com'
        fill_in I18n.t(:'simple_form.labels.user.password'), with: 'new password'
        fill_in I18n.t(:'simple_form.labels.user.password_confirmation'), with: 'new password'
        find('#user_current_password').set 'password'
        click_button I18n.t(:'devise.registrations.edit.update')
      end
    end

    scenario 'his information are updated' do
      expect(current_path).to eq(root_path)
      expect(page).to have_content I18n.t(:'devise.registrations.updated')
    end
  end
end
