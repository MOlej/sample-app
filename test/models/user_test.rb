require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Foo Bar", email: "foo@bar.com", password: "qwerty123", password_confirmation: "qwerty123")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "x" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "x" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com ....@example.com user@example..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email address should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email.upcase!
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email address should be saved as lower-case" do
    mixed_case_email = "FoOBaR@ExaMple.COm"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test"password should have a minimum length" do
    @user.password = @user.password_confirmation = "x" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    test_user = users(:test_user)
    test_user2 = users(:test_user2)
    assert test_user.following?(test_user2)
    assert test_user2.followers.include?(test_user)
    test_user.unfollow(test_user2)
    assert_not test_user.following?(test_user2)
    test_user.follow(test_user2)
    assert test_user.following?(test_user2)
  end

  test "feed should have the right posts" do
    admin = users(:admin)
    test_user = users(:test_user)
    test_user2 = users(:test_user2)
    # Posts from followed user
    test_user.microposts.each do |post_following|
      assert admin.feed.include?(post_following)
    end
    # Posts from self
    admin.microposts.each do |post_self|
      assert admin.feed.include?(post_self)
    end
    # Posts from unfollowed user
    test_user2.microposts.each do |post_unfollowed|
      assert_not admin.feed.include?(post_unfollowed)
    end
  end
end
