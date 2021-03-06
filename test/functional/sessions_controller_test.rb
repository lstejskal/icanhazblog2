require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  test "routing log_in -> new session" do
    assert_routing log_in_path, { :controller => "sessions", :action => "new" }
  end  

  test "routing log_out -> destroy session" do
    assert_routing log_out_path, { :controller => "sessions", :action => "destroy" }
  end

  context "user" do

    setup do
      @user = Factory.create(:admin_user)
    end
      
    teardown do
      @user.destroy
    end

    should "view login form" do
      get :new
      assert_response :success
      assert_template :new
    end

    should "not log in with invalid password" do
      post :create, :email => @user.email, :password => @user.password.reverse
      assert_response :success
      assert_template :new
      assert_not_nil flash.alert
    end

    should "log in with valid password" do
      post :create, :email => @user.email, :password => @user.password
      assert_redirected_to root_path
      assert_not_nil flash.notice
      assert_equal @user.to_param, session[:user_id]
    end

  end
  
  context "logged-in admin" do

    setup do
      @user = Factory.create(:admin_user)
      post :create, :email => @user.email, :password => @user.password
    end
      
    teardown do
      @user.destroy
    end

    should "be identified as admin" do
      assert @controller.send(:admin?)
    end

    should "have access to restricted pages" do
      @controller.send(:admin_access_required)
      assert :success
      assert_nil flash.alert
    end

    should "log out" do
      assert session[:user_id]
      get :destroy
      assert_redirected_to root_path
      assert_not_nil flash.notice
      assert ! session[:user_id]
    end

  end

end
