class Task < ApplicationRecord
  belongs_to :user

  after_save :schedule_reminders

  has_rich_text :description

  validates :title, :description, :deadline, presence: true
  validates :title, length: { maximum: 255 }
  validate :deadline_cannot_be_in_the_past

  enum state: { backlog: 0, in_progress: 1, done: 2 }

  scope :order_by_custom_criteria, lambda {
    order(Arel.sql("
      CASE
        WHEN state = #{states[:backlog]} AND deadline <= NOW() + INTERVAL '24 HOURS' THEN 1
        WHEN state = #{states[:in_progress]} THEN 2
        WHEN state = #{states[:backlog]} THEN 3
        WHEN state = #{states[:done]} THEN 4
      END, deadline ASC
    "))
  }

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
