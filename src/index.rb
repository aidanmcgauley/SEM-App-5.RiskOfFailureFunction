require 'sinatra'
require 'json'
require 'sinatra/cross_origin'
require_relative 'functions'

set :port, 8005

configure do
    enable :cross_origin
end
  
before do
    response.headers['Access-Control-Allow-Origin'] = 'http://localhost:8000'
end

# I was having CORS issues, so needed to include some headers to connect frontend and backend
options '*' do
    response.headers["Allow"] = "GET, POST"
    response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
    response.headers["Access-Control-Allow-Origin"] = "*"
    200
end

get '/' do
    # grab the engagement score and cut-off score from the parameters
    engagement_score_param = params['engagement_score']
    cut_off_score_param = params['cut_off_score']

    # call the function that runs validation checks. It returns the scores now converted to ints
    engagement_score, cut_off_score = validate_parameters(engagement_score_param, cut_off_score_param)

    # ternary conditional operator
    risk = engagement_score < cut_off_score ? "at risk" : "not at risk"

    # respond with the risk status, engagement score, and cut-off score as JSON
    content_type :json
    { :risk => risk, :engagement_score => engagement_score, :cut_off_score => cut_off_score }.to_json

end