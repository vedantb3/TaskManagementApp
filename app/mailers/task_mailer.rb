class TaskMailer < ApplicationMailer
  def reminder_email(task, time_left)
    @task = task
    @time_left = time_left
    mail(to: @task.user.email, subject: "Task Deadline Reminder: #{task.title}")
  end
end
