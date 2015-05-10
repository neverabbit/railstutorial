require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @admin = users(:test)
    @non_admin = users(:name)
  end
  
  test "index as admin including pagination and delete links" do
    log_in_as(@admin, password: 'testtest')
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete', method: :delete
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end
  
  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
  
  
  test "should show activated users when calling 'users'" do
    log_in_as(@admin)
    @non_admin.toggle!(:activated)
    get users_path
    assert_select 'a[href=?]', user_path(@non_admin), { count: 0 }, text: 'delete', method: :delete 
    get user_path(@non_admin)
    assert_redirected_to root_url
  end
end
