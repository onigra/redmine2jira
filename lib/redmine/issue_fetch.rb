require_relative './issue_factory'
require 'pp'

CSV.foreach("./files/sample.csv", headers: true, encoding: "CP932") do |line|
  response = RestClient.get("#{Redmine::Config::BASE_URL}/issues/#{line['no']}.json?include=journals", Redmine::Config::HEADERS)
  redmine_issue = Redmine::IssueFactory.create(JSON.parse response.body)
  pp redmine_issue
end
