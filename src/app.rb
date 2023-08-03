# app.rb
require 'sinatra'
require 'json'
require 'sinatra/cross_origin'
set :port, 8005

configure do
    enable :cross_origin
end
  
before do
response.headers['Access-Control-Allow-Origin'] = 'http://localhost:8000'
end

options '*' do
response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
response.headers["Access-Control-Allow-Origin"] = "*"
200
end

get '/' do
    # grab the engagement score and cut-off score from the parameters
    engagement_score_param = params['engagement_score']
    cut_off_score_param = params['cut_off_score']

    # Check if engagement score is an int
    if engagement_score_param !~ /^\d+$/
        content_type :json
        status 400
        return { :error => "Invalid parameter. The calculated engagement score was not an integer." }.to_json
    end

    # Check if cut-off score is an int
    if cut_off_score_param !~ /^\d+$/
        content_type :json
        status 400
        return { :error => "Invalid input. Cut-off Engagement Score must be an integer." }.to_json
    end

    engagement_score = engagement_score_param.to_i
    cut_off_score = cut_off_score_param.to_i

    # Check if engagement score is within the valid range
    if engagement_score < 0 || engagement_score > 100 || cut_off_score < 0 || cut_off_score > 100
        content_type :json
        status 400
        return { :error => "Invalid input. The calculated engagement score must be between 0 and 100." }.to_json
    end

    # Check if cut-off score is within the valid range
    if cut_off_score < 0 || cut_off_score > 100
        content_type :json
        status 400
        return { :error => "Invalid input. Cut-off score must be between 0 and 100." }.to_json
    end

    # check if the student is at risk
    risk = engagement_score < cut_off_score ? "at risk" : "not at risk"

    # respond with the risk status, engagement score, and cut-off score as JSON
    content_type :json
    { :risk => risk, :engagement_score => engagement_score, :cut_off_score => cut_off_score }.to_json
end