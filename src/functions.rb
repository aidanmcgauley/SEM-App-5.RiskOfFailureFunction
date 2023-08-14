def validate_parameters(engagement_score_param, cut_off_score_param)

    # Check if engagement score is an int
    # ChatGPT generated this regular expression which works for my purposes. Matches digits 0-9.
    if engagement_score_param !~ /^\d+$/
        return { error: "Invalid parameter. The calculated engagement score for your attendance was not an integer.", status: 400 }
    end

    # Check if cut-off score is an int
    # Same regex as above
    if cut_off_score_param !~ /^\d+$/
        return { :error => "Invalid input. Cut-off Engagement Score must be an integer.", status: 400 }
    end

    # convert to ints if they're ints
    engagement_score = engagement_score_param.to_i
    cut_off_score = cut_off_score_param.to_i

    # Check if engagement score is within the valid range
    if engagement_score < 0 || engagement_score > 100
        return { :error => "Invalid parameter. The calculated engagement score for your attendance must be between 0 and 100.", status:400 }
    end

    # Check if cut-off score is within the valid range
    if cut_off_score < 0 || cut_off_score > 100
        return { :error => "Invalid input. Cut-off score must be between 0 and 100.", status:400 }
    end

    # Return the converted values
    [engagement_score, cut_off_score]
    
end