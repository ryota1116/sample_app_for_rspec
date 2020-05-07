require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:task) { create(:task, user_id: user.id) }
  let(:other_task) { create(:task, user_id: other_user.id) }

  describe 'ログイン前' do
    describe 'ページ遷移の確認' do
      context 'タスクの新規作成ページにアクセス' do
        it 'アクセスが失敗すること' do
          visit new_task_path
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end
      context 'タスクの編集ページにアクセス' do
        it 'アクセスが失敗すること' do
          visit edit_task_path(task)
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end
      context 'タスクの詳細ページにアクセス' do
        it 'アクセスが失敗すること' do
          visit task_path(task)
          expect(current_path).to eq task_path(task)
          expect(page).to have_content task.title
        end
      end
      context 'タスクの一覧ページにアクセス' do
        it 'アクセスが失敗すること' do
          task
          other_task
          visit tasks_path
          expect(current_path).to eq tasks_path
          expect(page).to have_content task.title
          expect(page).to have_content other_task.title
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login(user) }
    describe 'タスクの新規作成' do
      before { visit new_task_path }
      context 'フォームの入力が正常の場合' do
        it 'タスクの作成に成功すること' do
          fill_in 'Title', with: 'タスクのタイトル'
          select 'todo', from: 'Status'
          click_button 'Create Task'
          expect(page).to have_content 'タスクのタイトル'
          expect(page).to have_content 'Task was successfully created.'
          expect(current_path).to eq '/tasks/1'
        end
      end
      context 'タイトルが未入力の場合' do
        it 'タスクの作成に失敗すること' do
          fill_in 'Title', with: ''
          select 'todo', from: 'Status'
          click_button 'Create Task'
          expect(page).to have_content  '1 error prohibited this task from being saved'
          expect(page).to have_content  "Title can't be blank"
          expect(current_path).not_to eq '/tasks/1'
        end
      end
      context '登録済のタイトルを入力した場合' do
        it 'タスクの作成に失敗すること' do
          fill_in 'Title', with: other_task.title
          select 'todo', from: 'Status'
          click_button 'Create Task'
          expect(page).to have_content  '1 error prohibited this task from being saved'
          expect(page).to have_content  "Title has already been taken"
          expect(current_path).not_to eq '/tasks/1'
        end
      end
    end
    describe 'タスクの編集' do
      before do
        task = create(:task, user_id: user.id)
        visit edit_task_path(task)
      end
      context 'フォームの入力が正常の場合' do
        it 'タスクの編集に成功すること' do
          fill_in 'Title', with: '新しいタイトル'
          select :done, from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content '新しいタイトル'
          expect(page).to have_content 'done'
          expect(page).to have_content 'Task was successfully updated.'
          expect(current_path).to eq '/tasks/1'
        end
      end
      context 'タイトルが未入力の場合' do
        it 'タスクの編集に失敗すること' do
          fill_in 'Title', with: nil
          select :todo, from: 'Status'
          click_button 'Update Task'
          within('#error_explanation') do
            expect(page).to have_content  '1 error prohibited this task from being saved'
            expect(page).to have_content "Title can't be blank"
          end
          expect(current_path).to eq '/tasks/1'
        end
      end
      context '登録済みのタイトルを入力した場合' do
        it 'タスクの編集に失敗すること' do
          fill_in 'Title', with: other_task.title
          select :todo, from: 'Status'
          click_button 'Update Task'
          within('#error_explanation') do
            expect(page).to have_content  '1 error prohibited this task from being saved'
            expect(page).to have_content "Title has already been taken"
          end
          expect(current_path).to eq '/tasks/1'
        end
      end
    end
    describe 'タスクの削除' do
      context '自分のタスクの削除リンクをクリック場合' do
        it 'クリックしたタスクが削除されること' do
          task = create(:task, user_id: user.id)
          visit tasks_path
          click_link 'Destroy'
          expect(page.accept_confirm).to eq 'Are you sure?'
          expect(page).to have_content 'Task was successfully destroyed'
          expect(current_path).to eq tasks_path
          expect(page).not_to have_content task.title
        end
      end
    end
  end
end
