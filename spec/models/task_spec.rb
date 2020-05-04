require 'rails_helper'

RSpec.describe Task, type: :model do

  it 'titleとstatusが存在すれば有効であること' do
    task = Task.new(title: 'タイトル', status: :doing)
    expect(task).to be_valid
  end

  it 'titleが存在しない場合無効であること' do
    task = FactoryBot.build(:task, title: nil)
    task.valid?
    expect(task.errors[:title]).to include("can't be blank")
  end

  it 'statusが存在しない場合無効であること' do
    task = FactoryBot.build(:task, status: nil)
    task.valid?
    expect(task.errors[:status]).to include("can't be blank")
  end

  it 'titleが重複する場合無効であること' do
    task = FactoryBot.create(:task, title: 'タイトル')
    task2 = FactoryBot.build(:task, title: 'タイトル')
    task2.valid?
    expect(task2.errors[:title]).to include('has already been taken')
  end

  it 'titleが重複しない場合有効であること' do
    task = FactoryBot.create(:task, title: 'タイトル')
    task2 = FactoryBot.build(:task, title: 'タイトル2')
    task2.valid?
    expect(task2).to be_valid
  end
end
