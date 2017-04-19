module Redmine
  class Config
    BASE_URL = ENV['REDMINE_URL']

    HEADERS = {
      "X-Redmine-API-Key" => ENV['REDMINE_API_KEY']
    }
  end
end
