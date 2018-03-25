class SubtaskController < IssuesController

  def new
    logger.debug "goi:subtask:new #{@allowed_statuses}"

    render "plan/toto", layout: false
  end
end
