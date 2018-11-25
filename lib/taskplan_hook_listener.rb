require 'byebug'

class TaskplanHookListener < Redmine::Hook::ViewListener
  include IssuesHelper
  include RoutesHelper

  def view_issues_context_menu_start(context = {})
    issue = context[:issues][0]
    attrs = {
      :parent_issue_id => issue
    }
    attrs[:tracker_id] = issue.tracker unless issue.tracker.disabled_core_fields.include?('parent_issue_id')
    # create subtask
    l1 = link_to("new subtask", new_project_issue_path(issue.project, :issue => attrs, :back_url => project_issues_path(issue.project)))
    # byebug
    # TODO maintenir columns, order
    # filter subtasks
    l2 = link_to("filter sustasks", _project_issues_path(@project, :set_filter => 1,
      :f => ["parent_id", ""], 
      :op => {:parent_id => "~"},
      :v => {:parent_id => [issue.id]},
      :issue_id => ["1"]))
    # filter parent task 
    # byebug
    # TODO manage no grand_parent
    direct_parent_id = issue.parent.parent_id
    l3 = link_to("filter parent tasks", _project_issues_path(@project, :set_filter => 1,
    :f => ["parent_id", ""], 
    :op => {:parent_id => "~"},
    :v => {:parent_id => [direct_parent_id]}))
    return "<li>" + l1 + "</li>" +
          "<li>" + l2 + "</li>" +
          "<li>" + l3.to_s+ "</li>"
  end  
end