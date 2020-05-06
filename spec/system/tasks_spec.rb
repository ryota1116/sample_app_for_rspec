require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  describe 'タスクの新規作成' do
    let!(:user) { create(:user) }
    before do
      login(user)
    end

    context 'フォームの入力が正常の場合' do
      it 'タスクの作成に成功すること' do
        expect {
          click_link 'New Task'
          fill_in 'Title', with: 'タスクのタイトル'
          select 'todo', from: 'Status'
          click_button 'Create Task'

          expect(page).to have_content 'タスクのタイトル'
          expect(page).to have_content 'Task was successfully created.'
        }.to change{ user.tasks.count }.by(1)
        end
      end

    context 'フォームの入力が異常の場合' do
      it 'タスクの作成に失敗すること' do
        click_link 'New Task'
        click_button 'Create Task'

        expect(page).to have_selector 'h1', text: 'New Task'
        expect(page).to have_content "Title can't be blank"
        # expect(page).to have_content "Status can't be blank"
      end
    end

    context 'ログインしていないユーザーの場合' do
      it 'タスクの新規作成ページにアクセスできないこと' do

      end
    end

  end

  describe 'タスクの編集' do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    let!(:task) { create(:task, title: 'タイトル', user: user) }
    let!(:other_task) { create(:task, user: other_user) }

    context 'フォームの入力が正常の場合' do
      it 'タスクの編集に成功すること' do
        login(user)
        click_link 'Edit'
        fill_in 'Title', with: '新しいタイトル'
        click_button 'Update Task'

        expect(current_path).to eq task_path(task)
        expect(page).to have_content '新しいタイトル'
        expect(page).to have_content 'Task was successfully updated.'
      end
    end

    context 'フォームの入力が異常の場合' do
      it 'タスクの編集に失敗すること' do
        login(user)
        click_link 'Edit'
        fill_in 'Title', with: nil
        click_button 'Update Task'

        expect(page).to have_selector 'h1', text: 'Editing Task'
        expect(page).to have_content "Title can't be blank"
      end
    end

    context '他のユーザーのタスク編集ページにアクセス' do
      it 'アクセスに失敗すること' do
        login(user)
        visit edit_task_path(other_user)
        expect(current_path).to eq root_path
        expect(page).to have_content 'Forbidden access.'
      end
    end
  end

  context 'ログインしていないユーザーの場合' do
    it 'タスクの新規作成ページにアクセスできないこと' do
      visit new_task_path
      expect(current_path).to eq login_path
      expect(page).to have_content 'Login required'
    end
  end

  describe 'タスクの削除' do
    let!(:user) { create(:user) }
    let!(:task) { create(:task, user: user) }
    context '自分のタスクの場合' do
      it 'タスクの削除に成功すること' do
          login(user)
          click_link 'Destroy'
          expect{
            expect(page.accept_confirm).to eq 'Are you sure?'
            expect(current_path).to eq tasks_path
            expect(page).to have_content 'Task was successfully destroyed'
          }.to change{ Task.count }.by(-1)
      end
    end
  end
end
