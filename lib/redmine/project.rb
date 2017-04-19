require_relative './config'
require 'rest-client'
require 'pp'
require 'json'

url = "#{Redmine::Config::BASE_URL}/projects.json?limit=100"
response = RestClient.get url
res = JSON.parse response.body
# r = res['projects'].select { |i| i['name'] == "sample" }
pp res
