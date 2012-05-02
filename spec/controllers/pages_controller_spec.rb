require 'spec_helper'

describe PagesController do
  render_views
  
  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  describe "GET 'home'" do
    
    describe "when not signed in" do

      before(:each) do
        get :home
      end

      it "should be successful" do
        response.should be_success
      end

      it "should have the right title" do
        response.should have_selector("title",
                                      :content => "#{@base_title} | Home")
      end
      
      it "should have a non-blank body" do
        response.body.should_not =~ /<body>\s*<\/body>/
      end
      
    end
    
    # Test for exercise 11.2
    describe "when signed in" do
      
      before(:each) do
        @user = test_sign_in(Factory(:user))
        other_user = Factory(:user, :email => Factory.next(:email))
        other_user.follow!(@user)
      end
      
      it "should have the right follower/following counts" do
        get :home
        response.should have_selector("a", :href => following_user_path(@user),
                                           :content => "0 following")
        response.should have_selector("a", :href => followers_user_path(@user),
                                           :content => "1 follower")
      end
      
      it "by user with no microposts should display 0 microposts" do
        get 'home'
        response.should have_selector("span.microposts", :content => "0 microposts")
      end
      
      it "by user with 1 micropost should display 1 micropost" do
        @mp1 = Factory(:micropost, :user => @user)
        get 'home'
        response.should have_selector("span.microposts", :content => "1 micropost")
      end
      
      it "by user with 2 microposts should display 2 microposts" do
        @mp1 = Factory(:micropost, :user => @user)
        @mp2 = Factory(:micropost, :user => @user)
        get 'home'
        response.should have_selector("span.microposts", :content => "2 microposts")
      end
      
      # Test for exercise 11.4
      it "should paginate microposts" do
        31.times do
          Factory(:micropost, :user => @user)
        end
        get 'home'
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/?page=2",
                                           :content => "2")
        response.should have_selector("a", :href => "/?page=2",
                                           :content => "Next")
      end
      # Test for exercise 11.4
      
      # Test for exercise 11.6
      describe "delete link" do
        
        before(:each) do
          @content1 = "foo bar"
          mp1 = Factory(:micropost, :content => @content1, :user => @user)
          @content2 = "baz qux"
          mp2 = Factory(:micropost, :content => @content2, 
                        :user => Factory(:user, :email => Factory.next(:email)))
          get 'home'
        end
        
        it "should not show for other user's microposts" do
          response.should_not have_selector("table.microposts>tr>td>a",
                                            :content => "delete",
                                            :title   => @content2,
                                            :href    => "/microposts/2")
        end
        
        it "should show for user's microposts" do
          response.should have_selector("table.microposts>tr>td>a",
                                        :content => "delete",
                                        :title   => @content1,
                                        :href    => "/microposts/1")
        end
        
      end
      # Test for exercise 11.6
      
    end
    # Test for exercise 11.2
    
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'contact'
      response.should have_selector("title",
                        :content => "#{@base_title} | Contact")
    end
  end
  
  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'about'
      response.should have_selector("title",
                        :content => "#{@base_title} | About")
    end
  end
  
  describe "GET 'help'" do
    it "should be successful" do
      get 'help'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'help'
      response.should have_selector("title",
                        :content => "#{@base_title} | Help")
    end
  end
  
end

