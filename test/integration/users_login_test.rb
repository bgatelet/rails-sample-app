require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # users references to the users.yml file, and :michael to the user in users.yml.
  def setup
    @user = users(:michael)
  end

  test "login with valid information flash test" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: {email: "", password: ""}
    assert_template 'sessions/new'
    assert_not flash.empty?

    # Test whether or not flash persists on other pages.
    get root_path
    assert flash.empty?
  end

  test "login with valid information" do
    get login_path
    post login_path, session: { email: @user.email, password: 'password'}
    assert is_logged_in?
    assert_redirected_to @user
    # Actually visit the redirected page
    follow_redirect!
    assert_template 'users/show'
    # Verify login link disapears
    assert_select "a[href = ?]", login_path, count: 0
    assert_select "a[href = ?]", logout_path
    assert_select "a[href = ?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # Simulate logging out of second window
    delete logout_path
    follow_redirect!
    assert_select "a[href = ?]", login_path
    assert_select "a[href = ?]", logout_path, count: 0
    assert_select "a[href = ?]", user_path(@user), count: 0
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_nil cookies['remember_token']
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end
end
