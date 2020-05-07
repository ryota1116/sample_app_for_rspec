require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  let(:user) { create(:user) }
  describe 'ログイン機能' do
    before do
      visit root_path
      click_link 'Login'
    end

    context "フォームの入力が正常の場合" do
      it 'ログインに成功すること' do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: 'password'
        click_button 'Login'
        expect(page).to have_content 'Login successful'
        expect(current_path).to eq root_path
      end
    end

    context "フォームの入力が異常の場合" do
      it 'ログインに失敗すること' do
        fill_in 'Email', with: nil
        fill_in 'Password', with: nil
        click_button 'Login'
        expect(page).to have_content 'Login failed'
        expect(current_path).to eq login_path
      end
    end
  end

  describe 'ログアウト機能' do
    context "ログアウトボタンをクリックした場合" do
      it 'ログアウトに成功すること' do
        login(user)
        click_link 'Logout'
        expect(page).to have_content 'Logged out'
        expect(current_path).to eq root_path
      end
    end
  end
end
