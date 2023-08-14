require 'minitest/autorun'
require_relative 'functions'

class TestValidateParameters < Minitest::Test
  def test_valid_parameters
    # integer values expected to be returned and assigned
    engagement_score, cut_off_score = validate_parameters('50', '40')
    assert_equal 50, engagement_score
    assert_equal 40, cut_off_score
  end

  def test_invalid_engagement_score
    # Assign to result instead of 2 scores for invalid parameters
    # because an error message will be returned isntead
    result = validate_parameters('abc', '40')
    assert_equal "Invalid parameter. The calculated engagement score for your attendance was not an integer.", result[:error]
  end

  def test_invalid_cut_off_score
    result = validate_parameters('50', 'abc')
    assert_equal "Invalid input. Cut-off Engagement Score must be an integer.", result[:error]
  end

  def test_engagement_score_out_of_range_low
    result = validate_parameters('-5', '50')
    assert_equal "Invalid parameter. The calculated engagement score for your attendance must be between 0 and 100.", result[:error]
  end
  
  def test_engagement_score_out_of_range_high
    result = validate_parameters('105', '50')
    assert_equal "Invalid parameter. The calculated engagement score for your attendance must be between 0 and 100.", result[:error]
  end

  def test_cut_off_score_out_of_range_low
    result = validate_parameters('50', '-10')
    assert_equal "Invalid input. Cut-off score must be between 0 and 100.", result[:error]
  end
  
  def test_cut_off_score_out_of_range_high
    result = validate_parameters('50', '110')
    assert_equal "Invalid input. Cut-off score must be between 0 and 100.", result[:error]
  end
  
end