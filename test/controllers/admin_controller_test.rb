require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test 'should get email' do
    get :email
    assert_response :success
  end

  test 'should get scrape' do
    get :scrape
    assert_response :success
  end
end
