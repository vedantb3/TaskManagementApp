class Task < ApplicationRecord
  include AASM

  belongs_to :user

  after_save :schedule_reminders

  has_rich_text :description

  validates :title, :description, :deadline, presence: true
  validates :title, length: { maximum: 255 }
  validate :deadline_cannot_be_in_the_past

  scope :order_by_custom_criteria, lambda {
    order(Arel.sql("
      CASE
        WHEN state = 'backlog' AND deadline <= NOW() + INTERVAL '24 HOURS' THEN 1
        WHEN state = 'in_progress' THEN 2
        WHEN state = 'backlog' THEN 3
        WHEN state = 'done' THEN 4
      END, deadline ASC
    "))
  }

  aasm column: 'state' do
    state :backlog, initial: true
    state :in_progress
    state :done

    event :start do
      transitions from: :backlog, to: :in_progress
    end

    event :complete do
      transitions from: :in_progress, to: :done
    end
  end

  def deadline_cannot_be_in_the_past
    return unless deadline.present? && deadline < Time.current

    errors.add(:deadline, "can't be in the past")
  end

  def schedule_reminders
    return unless deadline.present? && state != 'done'

    TaskReminderJob.set(wait_until: deadline - 1.day).perform_later(id, '1 day')
    TaskReminderJob.set(wait_until: deadline - 1.hour).perform_later(id, '1 hour')
  end
end
