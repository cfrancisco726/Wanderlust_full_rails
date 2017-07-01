require 'test_helper'

class SesssionsControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get sesssions_login_url
    assert_response :success
  end

end
