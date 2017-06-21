require 'test_helper'

class GardenTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    login_user(user = @user, route = login)
    @garden = @user.garden.build
  end

  test "garden should have postal code" do 
    @garden.postal_code = ""
    assert_not @garden.valid?
  end
end
