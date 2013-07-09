require 'spec_helper'

describe "User pages" do
    
    subject { page }

    describe "index" do
        before do
            #test this without the parentheses around FactoryGirl
            sign_in(FactoryGirl.create(:user))
            FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
            FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
            #test with parentheses around users_path
            visit users_path
        end

        it { should have_selector('title', text: 'All users') }
        it { should have_selector('h1', text: 'All users') }

        it "should list each user" do
            User.all.each do |user|
                page.should have_selector('li', text: user.name)
            end
        end
    end

    describe "signup" do
        before { visit signup_path }
        let(:submit) { "Create my account" }

        it { should have_selector('h1', text: 'Sign up') }
        it { should have_selector('title', text: full_title('Sign up')) }

        describe "with invalid information" do
            it "should not create a user" do
                expect { click_button submit }.not_to change(User, :count)
            end
        end

        describe "with valid information" do
            before do
                fill_in "Name",     with: "Example User"
                fill_in "Email",    with: "user@example.com"
                fill_in "Password", with: "foobar"
                fill_in "Confirmation", with: "foobar" 
            end

            it "should create a user" do
                expect { click_button submit }.to change(User, :count).by(1)
            end

            describe "after saving the user" do
                before { click_button submit }
                it { should have_link('Sign out') }
            end
        end
    end

    describe "profile page" do
        # Code to make a user variable
        let(:user) { FactoryGirl.create(:user) }
        before { visit user_path(user) }

        it { should have_selector('h1',    text: user.name) }
        it { should have_selector('title', text: user.name) }
    end

    describe "edit" do
        let(:user) { FactoryGirl.create(:user) }
        before do
            sign_in user
            visit edit_user_path(user) 
        end

        describe "page" do
            it { should have_selector('h1',    text: "Update your profile") }
            it { should have_selector('title', text: "Edit user") }
            it { should have_link('change', href: 'http://gravatar.com/emails') }
        end

        describe "with invalid information" do
            before { click_button "Save changes" }

            it { should have_content('error') }
        end

        describe "with valid information" do
            let(:new_name) { "New Name" }
            let(:new_email) { "new@example.com" }
            before do
                fill_in "Name",     with: new_name
                fill_in "Email",    with: new_email
                fill_in "Password",  with: user.password
                fill_in "Confirm Password",  with: user.password
                click_button "Save changes"
            end

            it { should have_selector('title', text: new_name) }
            it { should have_selector('div.alert.alert-success') }
            it { should have_link('Sign out', href: signout_path) }
            specify { user.reload.name.should == new_name }
            specify { user.reload.email.should == new_email } 
        end
    end
end