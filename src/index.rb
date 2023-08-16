require 'sinatra'
require 'json'
require 'sinatra/cross_origin'
require_relative 'functions'

set :port, 8005

configure do
    enable :cross_origin
end
  
before do
    response.headers['Access-Control-Allow-Origin'] = 'http://sem-frontend.40058902.qpc.hal.davecutting.uk/'
end

# I was having CORS issues, so needed to include some headers to connect frontend and backend
options '*' do
    response.headers["Allow"] = "GET, POST"
    response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
    response.headers["Access-Control-Allow-Origin"] = "*"
    200
end

get '/' do
    engagement_score_param = params['engagement_score']
    cut_off_score_param = params['cut_off_score']
  
    validation_result = validate_parameters(engagement_score_param, cut_off_score_param)
  
    # The function should return a hash if there's an error, and there should be an error message
    if validation_result.is_a?(Hash) && validation_result[:error]
        content_type :json
        status validation_result[:status] # Use the status code returned by validate_parameters
        return { error: validation_result[:error] }.to_json
    else
        engagement_score, cut_off_score = validation_result
        risk = engagement_score < cut_off_score ? "at risk" : "not at risk"
        content_type :json
        { risk: risk, engagement_score: engagement_score, cut_off_score: cut_off_score }.to_json
    end
  end