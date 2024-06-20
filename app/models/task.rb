class Task < ApplicationRecord
  include AASM

  belongs_to :user

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
end
