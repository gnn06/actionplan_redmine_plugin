#require_dependency 'issue_patch'

Redmine::Plugin.register :plan do
  name 'Plan plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  project_module :plan do
    permission :add_subtask, :subtask => :new
  end

  menu :application_menu, :plan, { :controller => 'plan', :action => 'index' }, :caption => 'Plan'
end

#logger.debug "goi:init.rb"
