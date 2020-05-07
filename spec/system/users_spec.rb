require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:task) { create(:task) }
  describe 'ログイン前' do
    describe 'ユーザーの新規作成' do
      before do
        visit root_path
        click_link 'SignUp'
      end

      context 'フォームの入力が正常の場合' do
        it '新規作成に成功すること' do
          expect {
          fill_in 'Email', with: 'test@example.com'
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'
          expect(page).to have_content 'User was successfully created.'
          expect(current_path).to eq login_path
          }.to change{ User.count }.by(1)
        end
      end

      context 'メールアドレスが未入力の場合' do
        it '新規作成に失敗すること' do
          fill_in 'Email', with: nil
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'
          within('#error_explanation') do
            expect(page).to have_content "1 error prohibited this user from being saved"
            expect(page).to have_content "Email can't be blank"
          end
          expect(current_path).to eq users_path
        end
      end

      context '登録済メールアドレスを入力した場合' do
        it '新規作成に失敗すること' do
            fill_in 'Email', with: user.email
            fill_in 'Password', with: 'password'
            fill_in 'Password confirmation', with: 'password'
            click_button 'SignUp'
            within('#error_explanation') do
              expect(page).to have_content "1 error prohibited this user from being saved"
              expect(page).to have_content 'Email has already been taken'
            end
            expect(current_path).to eq users_path
            expect(page).to have_field 'Email', with: user.email
        end
      end

      context 'パスワードを3文字未満で入力した場合' do
        it '新規作成に失敗すること' do
            fill_in 'Email', with: 'test_1@example.com'
            fill_in 'Password', with: 'ps'
            fill_in 'Password confirmation', with: 'ps'
            click_button 'SignUp'
            within('#error_explanation') do
              expect(page).to have_content "1 error prohibited this user from being saved"
              expect(page).to have_content 'Password is too short (minimum is 3 characters)'
            end
            expect(current_path).to eq users_path
        end
      end

      describe 'マイページ' do
        context 'ログインしていない場合' do
          it 'マイページへのアクセスが失敗する' do
            visit user_path(user)
            expect(page).to have_content 'Login required'
            expect(current_path).to eq login_path
          end
        end
      end
    end
  end


  describe 'ユーザーの編集' do
    describe 'ログイン後' do
      before do
        login(user)
        visit edit_user_path(user)
      end

      context 'フォームの入力が正常の場合' do
        it 'ユーザーの編集に成功すること' do
          fill_in 'Email', with: 'new_test@example.com'
          click_button 'Update'
          expect(page).to have_content 'User was successfully updated.'
          expect(current_path).to eq user_path(user)
          expect(page).to have_content 'new_test@example.com'
        end
      end

      context 'メールアドレスが未入力の場合' do
        it 'ユーザーの編集に失敗すること' do
          fill_in 'Email', with: ''
          click_button 'Update'
          within('#error_explanation') do
            expect(page).to have_content "1 error prohibited this user from being saved"
            expect(page).to have_content "Email can't be blank"
          end
          expect(current_path).to eq user_path(user)
          expect(page).to have_field 'Email', with: ''
        end
      end

      context '登録済メールアドレスを入力した場合' do
        it 'ユーザーの編集に失敗すること' do
          fill_in 'Email', with: other_user.email
          click_button 'Update'
          within('#error_explanation') do
            expect(page).to have_content "1 error prohibited this user from being saved"
            expect(page).to have_content 'Email has already been taken'
          end
          expect(current_path).to eq user_path(user)
          expect(page).to have_field 'Email', with: other_user.email
        end
      end

      context '他のユーザーのユーザー編集ページにアクセス' do
        it 'アクセスに失敗すること' do
          visit edit_user_path(other_user)
          expect(page).to have_content "Forbidden access."
          expect(current_path).to eq user_path(user)
        end
      end

      describe 'マイページ' do
        it '自分が新規作成したタスクが表示されること' do
          task = create(:task, user: user)
          visit user_path(user)
          expect(page).to have_content task.title
          expect(current_path).to eq user_path(user)
        end
      end
    end
  end
end