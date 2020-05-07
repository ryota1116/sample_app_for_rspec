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
      let!(:user) { create(:user) }
      it '新規作成に失敗すること' do
        expect{
          fill_in 'Email', with: user.email
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

  describe 'ユーザーの編集' do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }

    before do
      login(user)
      click_link 'Mypage'
      click_link 'Edit'
    end

    context 'フォームの入力が正常の場合' do
      it 'ユーザーの編集に成功すること' do
        fill_in 'Email', with: 'edit@example.com'
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'password'
        click_button 'Update'

        expect(current_path).to eq user_path(user)
        expect(page).to have_content 'User was successfully updated.'
        expect(page).to have_content 'edit@example.com'
      end
    end

    context 'メールアドレスが未入力の場合' do
      it 'ユーザーの編集に失敗すること' do
        fill_in 'Email', with: nil
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'password'
        click_button 'Update'

        expect(page).to have_selector 'h1', text: 'Editing User'
        expect(page).to have_content "Email can't be blank"
      end
    end

    context '登録済メールアドレスを入力した場合' do
      it 'ユーザーの編集に失敗すること' do
        fill_in 'Email', with: other_user.email
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'password'
        click_button 'Update'

        expect(page).to have_selector 'h1', text: 'Editing User'
        expect(page).to have_content 'Email has already been taken'
      end
    end

    context '他のユーザーのユーザー編集ページにアクセス' do
      it 'アクセスに失敗すること' do
        visit edit_user_path(other_user)

        expect(current_path).to eq user_path(user)
        expect(page).to have_content "Forbidden access."
      end
    end
  end

  describe 'マイページ' do
    let!(:user) { create(:user) }

    it '自分が新規作成したタスクが表示されること' do
      login(user)
      click_link 'New Task'
      fill_in 'Title', with: 'タスクのタイトル'
      select 'todo', from: 'Status'
      click_button 'Create Task'
      expect(page).to have_content 'タスクのタイトル'
      expect(page).to have_content 'todo'
    end
  end
end