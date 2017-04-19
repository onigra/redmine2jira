module Jira
  class Config
    CLIENT_OPTIONS = {
      username: ENV['JIRA_USERNAME'],
      password: ENV['JIRA_PASSWORD'],
      site: ENV['JIRA_URL'],
      context_path: '',
      auth_type: :basic,
    }
  end
end
