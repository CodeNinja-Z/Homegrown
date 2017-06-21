require 'test_helper'

class UserTest < ActiveSupport::TestCase
  include Sorcery::TestHelpers::Rails::Integration
  include Sorcery::TestHelpers::Rails::Controller

  # def setup
  #   @user = users(:one)
  #   login_user(user = @user, route = login)  # replace with your login url path
  # end

  # def setup
  #   @user = User.new(name: "Carlos", email: "cz1111@email.com", password: "1111", password_confirmation: "1111")
  # end

  # def setup
  #   create_new_user(attributes_hash = {name: "Carlos", email: "cz1111@email.com", password: "1111", password_confirmation: "1111"})
  # end

  setup do 
    @user = users(:one)
    puts @user.inspect  
  end

  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
    # above line is same as the following line:
    # assert @user.invalid?
  end

  test "email address should be unique" do
    dup_user = @user.dup
    dup_user.email = @user.email.upcase # To ensure email address is not case sensitive
    @user.save
    assert_not dup_user.valid?
  end

  test "email validation should accept valid email addresses" do
    valid_addresses = %w(user@eee.com R_TDD-DS@eee.hello.org user@example.com first.last@eem.au carlos+roxy@love.ca)
    valid_addresses.each do |va|
      @user.email = va
      assert @user.valid?, "#{va.inspect} should be valid" # Display a custom message here
    end
  end

  test "email validation should reject invalid email addresses" do
    invalid_addresses = %w(user@example,com user_at_eee.org user.name@example. eee@i_am_.com foo@ee+aar.com)
    invalid_addresses.each do |ia|
      @user.email = ia
    end
    assert_not @user.valid? "#{ia.inspect} should be invalid email address" # When one fails at any point, I want to know which one is failing.
  end
end
