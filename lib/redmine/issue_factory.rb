#
# RedmineとJIRAの対応
# redmine: jira
#
# subject: summary
# description: description
# journals.note: comment.body
#

require_relative './config'
require 'rest-client'
require 'json'
require 'csv'

module Redmine
  class IssueFactory
    def self.create(api_response)
      s = Struct.new(:summary, :description, :assignee, :comments)
      s.new(summary(api_response), description(api_response), assignee(api_response), comments(api_response))
    end

    private

    def self.summary(params)
      params["issue"]["subject"]
    end

    def self.description(params)
      params["issue"]["description"]
    end

    def self.assignee(params)
      if params["issue"].has_key?("assigned_to")
        res = RestClient.get("#{Redmine::Config::BASE_URL}/users/#{params["issue"]["assigned_to"]["id"]}.json", Redmine::Config::HEADERS)
        JSON.parse(res.body)["user"]["mail"].gsub(/@.*/, "")
      else
        nil
      end
    end

    def self.comments(params)
      params["issue"]["journals"].inject([]) { |result, j|
        result << { id: j["id"], comment: j["notes"] } unless (j["notes"] == "" || j["notes"].nil?)
        result
      }.sort_by { |i| i[:id] }
    end
  end
end
