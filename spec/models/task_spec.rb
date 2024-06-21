require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { create(:user) }

  subject {
    build(:task, title: "Test Task", description: "Task description", state: "backlog", deadline: Time.now + 1.day, user: user)
  }

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(255) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:deadline) }

    it "validates that deadline is not in the past" do
      subject.deadline = Time.now - 1.day
      expect(subject).to_not be_valid
      expect(subject.errors[:deadline]).to include("can't be in the past")
    end
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_rich_text(:description) }
  end

  describe "callbacks" do
    it "schedules reminders after save" do
      expect(TaskReminderJob).to receive(:set).twice.and_call_original
      subject.save
    end
  end

  describe "scopes" do
    it "orders by custom criteria" do
      task1 = create(:task, title: 'Task 1', description: 'Backlog Task', state: 'backlog', deadline: 1.day.from_now, user: user)
      task2 = create(:task, title: 'Task 2', description: 'In Progress Task', state: 'in_progress', deadline: 2.days.from_now, user: user)
      task3 = create(:task, title: 'Task 3', description: 'Backlog Task Near Deadline', state: 'backlog', deadline: Time.now + 12.hours, user: user)
      task4 = create(:task, title: 'Task 4', description: 'Done Task', state: 'done', deadline: 3.days.from_now, user: user)

      ordered_tasks = Task.order_by_custom_criteria

      expect(ordered_tasks).to eq([task3, task2, task1, task4])
    end
  end
end