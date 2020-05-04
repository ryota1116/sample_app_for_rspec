require 'rails_helper'

RSpec.describe Task, type: :model do

  it 'titleとstatusが存在すれば有効であること' do
    task = Task.new(title: 'タイトル', status: :doing)
    expect(task).to be_valid
  end

  it 'titleが存在しない場合無効であること' do
    task = build(:task, title: nil)
    expect(task).to be_invalid
    expect(task.errors[:title]).to include("can't be blank")
  end

  it 'statusが存在しない場合無効であること' do
    task = build(:task, status: nil)
    expect(task).to be_invalid
    expect(task.errors[:status]).to include("can't be blank")
  end

  it 'titleが重複する場合無効であること' do
    task = create(:task, title: 'タイトル')
    other_task = build(:task, title: 'タイトル')
    expect(other_task).to be_invalid
    expect(other_task.errors[:title]).to include('has already been taken')
  end

  it 'titleが重複しない場合有効であること' do
    task = create(:task, title: 'タイトル')
    other_task = build(:task, title: 'タイトル2')
    expect(other_task).to be_valid
  end
end
