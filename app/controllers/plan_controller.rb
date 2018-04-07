class PlanController < IssuesController

  #before_action :find_issue, :only => [:show, :subtask]
  skip_before_action :authorize, :only => [:subtask, :show]

  helper :issues

  def index
  end

  def show
    #byebug
    @issuePlan = @issue.descendants.visible.preload(:status, :priority, :tracker, :assigned_to)
    @backUrl = request.original_url
  end

  def subtask
    #byebug
    build_new_issue_from_params
    issue_to_add = @issue
    issue_to_add.parent_id = params[:id]
    find_issue
    issue_to_edit = @issue
    @issuePlan = @issue.descendants.visible.preload(:status, :priority, :tracker, :assigned_to)
    @issuePlan << issue_to_add
    logger.debug "goi:subtask #{edit_plan_path}"
    @backUrl = edit_plan_path
    render "show"
  end
end
