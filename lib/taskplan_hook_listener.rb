require 'byebug'

class TaskplanHookListener < Redmine::Hook::ViewListener
  include IssuesHelper
    def view_issues_context_menu_start(context = {})
      #byebug
      issue = context[:issues][0]
      attrs = {
        :parent_issue_id => issue
      }
      attrs[:tracker_id] = issue.tracker unless issue.tracker.disabled_core_fields.include?('parent_issue_id')
      l = link_to("new subtask", new_project_issue_path(issue.project, :issue => attrs, :back_url => issue_path(issue)))
      return "<li>" + l + "</li>"
    end  
  end