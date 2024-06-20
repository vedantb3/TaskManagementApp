class TaskReminderJob < ApplicationJob
  queue_as :default

  def perform(task_id, time_left)
    task = Task.find_by(id: task_id)

    return unless task && task.state != 'done' && (task.deadline - time_left_to_seconds(time_left)) > Time.current

    TaskMailer.reminder_email(task, time_left).deliver_now
  end

  private

  def time_left_to_seconds(time_left)
    case time_left
    when '1 day'
      1.day
    when '1 hour'
      1.hour
    else
      0
    end
  end
end
