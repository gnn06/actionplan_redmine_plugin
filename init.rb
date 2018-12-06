require_dependency 'actionplan_hook_listener'
require_dependency 'redmine_depth_issue_filter'

Redmine::Plugin.register :actionplan_redmine_plugin do
  name 'Actionplan Redmine Plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end
