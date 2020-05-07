require 'rails_helper'

RSpec.describe "UserSessions", type: :system do

  describe 'ログイン機能' do
    before do
      visit root_path
      click_link 'Login'
    end

    context "フォームの入力が正常の場合" do
      let(:user) { create(:user, password: 'password') }
      it 'ログインに成功すること' do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: 'password'
        click_button 'Login'
        expect(current_path).to eq root_path
        expect(page).to have_content 'Login successful'
      end
    end

    context "フォームの入力が異常の場合" do
      it 'ログインに失敗すること' do
        click_button 'Login'
        expect(page).to have_content 'Login failed'
      end
    end
  end

  describe 'ログアウト機能' do
    let!(:user) { create(:user, password: 'password') }
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
