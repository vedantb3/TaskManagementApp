module HomeHelper
  def truncate_rich_text(text, word_limit)
    if text.present?
      plain_text = sanitize(strip_tags(text.to_plain_text))
      words = plain_text.split
      if words.size > word_limit
        words.first(word_limit).join(' ') + '...'
      else
        plain_text
      end
    else
      ''
    end
  end

  def state_color_class(task_state)
    case task_state
    when 'backlog'
      'bg-danger'
    when 'in_progress'
      'bg-primary'
    when 'done'
      'bg-success'
    else
      ''
    end
  end
end
