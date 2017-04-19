require_relative './config'
require 'jira-ruby'
require 'pp'

client = JIRA::Client.new(Jira::Config::CLIENT_OPTIONS)
project = client.Project.find("SAMPLE")
# issue = client.Issue.find("SAMPLE-1")
issue = project.issues.first
pp issue.attrs

