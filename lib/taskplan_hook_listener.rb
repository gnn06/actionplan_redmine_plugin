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
    # filter subtasks
    # TODO maintenir columns, order
    # TODO manage saved query
    current_filters = context[:request].session[:issue_query][:filters]
    filters, operators, values = url_filters current_filters
    l2 = link_to("filter sustasks", _project_issues_path(@project, :set_filter => 1,
      :f  => filters << "parent_id", 
      :op => operators.merge({"parent_id" => "~"}),
      :v  => values.merge({"parent_id" => [issue.id.to_s]})))
    # filter parent task 
    # TODO manage no grand_parent
    direct_parent_id = issue.parent.parent_id
    l3 = link_to("filter parent tasks", _project_issues_path(@project, :set_filter => 1,
      :f  => filters << "parent_id",
      :op => operators.merge({"parent_id" => "~"}),
      :v  => values.merge({"parent_id" => [direct_parent_id.to_s]})))
    return "<li>" + l1 + "</li>" +
          "<li>" + l2 + "</li>" +
          "<li>" + l3 + "</li>"
  end

  def url_filters(filters_hash)
    filters = []
    operators = {}
    values = {}
    filters_hash.each do |key, value|
      filters << key
      operators[key] = value[:operator]
      values[key] = value[:values]
    end
    return filters, operators, values
  end
end