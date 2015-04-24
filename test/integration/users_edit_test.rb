require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @user = users(:test)
  end
  
  test "unsuccessful edit" do
    log_in_as(@user, password: 'testtest')
    get edit_user_path(@user)
    patch user_path(@user), user: { name: '', email: 'foo@invalid', password: 'foo', password_confirmation: 'bar' }
    assert_template 'users/edit'
  end
  
  test "successful edit" do
    log_in_as(@user, password: 'testtest')
    get edit_user_path(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), user: { name: name, email: email, password: '', password_confirmation: ''}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end
  
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user, password: 'testtest')
    assert_redirected_to edit_user_path(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), user: { name: name, email: email, password: '', password_confirmation: '' }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
    assert_nil session[:forwarding_url]
  end
end
