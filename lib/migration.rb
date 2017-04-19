require_relative './redmine/issue_factory'
require_relative './jira/config'
require 'jira-ruby'
require 'pp'

begin
  CSV.foreach("./files/sample.csv", headers: true, encoding: "CP932") do |line|
    response = RestClient.get("#{Redmine::Config::BASE_URL}/issues/#{line['no']}.json?include=journals", Redmine::Config::HEADERS)
    redmine_issue = Redmine::IssueFactory.create(JSON.parse response.body)

    issue_params = {
      fields: {
        summary: redmine_issue.summary,
        description: "#{Redmine::Config::BASE_URL}/issues/#{line['no']}\r\r#{redmine_issue.description}",
        project: { id: ENV['JIRA_PROJECT_ID'] },
        issuetype: { id: ENV['JIRA_ISSUE_TYPE_ID'] },
        assignee: { name: redmine_issue.assignee }
      }
    }

    client = JIRA::Client.new(Jira::Config::CLIENT_OPTIONS)
    issue = client.Issue.build
    issue.save(issue_params)

    redmine_issue.comments.each do |i|
      comment = issue.comments.build
      comment.save(body: i[:comment])
    end
  end
rescue => e
  pp line['no']
  pp e
  raise e
end
