require 'rails_helper'

RSpec.describe 'Users', type: :system do

  describe 'ユーザーの新規作成' do
    before do
      visit root_path
      click_link 'SignUp'
    end

    context 'フォームの入力が正常の場合' do
      it '新規作成に成功すること' do
        expect {
        fill_in 'Email', with: 'test_1@example.com'
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'password'
        click_button 'SignUp'

        expect(current_path).to eq login_path
        expect(page).to have_content 'User was successfully created.'
        }.to change{ User.count }.by(1)
      end
    end

    context 'メールアドレスが未入力の場合' do
      it '新規作成に失敗すること' do
        expect{
        fill_in 'Email', with: nil
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'password'
        click_button 'SignUp'

        expect(page).to have_selector 'h1', text: 'SignUp'
        expect(page).to have_content "Email can't be blank"
        }.to_not change{ User.count }
      end
    end

    context '登録済メールアドレスを入力した場合' do
      it '新規作成に失敗すること' do
        @user = create(:user)
        expect{
          fill_in 'Email', with: @user.email
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'

          expect(page).to have_selector 'h1', text: 'SignUp'
          expect(page).to have_content 'Email has already been taken'
        }.to_not change{ User.count }
      end
    end

    context 'パスワードを3文字未満で入力した場合' do
      it '新規作成に失敗すること' do
        expect{
          fill_in 'Email', with: 'test_1@example.com'
          fill_in 'Password', with: 'ps'
          fill_in 'Password confirmation', with: 'ps'
          click_button 'SignUp'

          expect(page).to have_selector 'h1', text: 'SignUp'
          expect(page).to have_content 'Password is too short (minimum is 3 characters)'
        }.to_not change{ User.count }
      end
    end
  end
end