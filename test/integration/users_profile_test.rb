require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:test_user)
    @user2 = users(:test_user2)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination'
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match CGI.escapeHTML(micropost.content), response.body
    end
    assert_select 'div.pagination', count: 1
    assert_select 'div.stats'
    assert_select 'div.stats>a', "#{@user.following.count}\n    \n    following"
    assert_select 'div.stats>a', "#{@user.followers.count}\n    \n    followers"
  end
end
