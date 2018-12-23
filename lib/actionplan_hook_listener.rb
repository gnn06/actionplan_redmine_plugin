require 'byebug'

class ActionplanHookListener < Redmine::Hook::ViewListener
  include IssuesHelper
  include RoutesHelper
  include ContextMenusHelper

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
    # TODO manage saved query
    current_filters = context[:request].session[:issue_query][:filters]
    query_params = url_filters current_filters
    l2 = context_menu_link("filter sustasks", _project_issues_path(@project, { :set_filter => 1,
      :f  => query_params[:filter] << "root_task", 
      :op => query_params[:operator].merge({"root_task" => "~"}),
      :v  => query_params[:value].merge({"root_task" => [issue.id.to_s]}),
      :sort => context[:request].session[:issue_query][:sort],
      :c => context[:request].session[:issue_query][:column_names],
      :group_by => context[:request].session[:issue_query][:group_by]}))
    # filter parent task 
    # TODO manage no grand_parent
    direct_parent_id = issue.parent_id
    if direct_parent_id then
      l3 = context_menu_link("filter parent tasks", _project_issues_path(@project, { :set_filter => 1,
        :f  => query_params[:filter] << "root_task",
        :op => query_params[:operator].merge({"root_task" => "="}),
        :v  => query_params[:value].merge({"root_task" => [direct_parent_id.to_s]}),
        :sort => context[:request].session[:issue_query][:sort],
        :c => context[:request].session[:issue_query][:column_names],
        :group_by => context[:request].session[:issue_query][:group_by]}))
    else
      l3 = context_menu_link("filter parent tasks", _project_issues_path(@project, { :set_filter => 1,
        :f  => query_params[:filter].without("root_task"),
        :op => query_params[:operator].without("root_task"),
        :v  => query_params[:value].without("root_task"),
        :sort => context[:request].session[:issue_query][:sort],
        :c => context[:request].session[:issue_query][:column_names],
        :group_by => context[:request].session[:issue_query][:group_by]}))
    end
    return "<li>" + l1 + "</li>" +
          "<li>" + l2 + "</li>" +
          "<li>" + l3 + "</li>"
  end

  def url_filters(filters_hash)
    result = { :filter => [], :operator => {}, :value => {}}
    filters_hash.each do |key, value|
      result[:filter] << key
      result[:operator].merge!({ key => value[:operator] })
      result[:value].merge!({ key =>  value[:values] })
    end
    result
  end
end