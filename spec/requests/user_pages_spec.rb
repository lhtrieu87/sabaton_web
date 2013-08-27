require 'spec_helper'

describe "User pages" do
    subject {page}
    describe "signup page" do
        before {visit signup_path}

        let(:submit) {"Create my account"}

        describe "with invalid information" do
            it "should not create a user" do
                expect {click_button submit}.not_to change(User, :count)
            end
            describe "after submission" do
                before {click_button submit}
                
                # Check redirected back to the Sign Up form
                it {should have_title('Sign Up')}
                # And error(s) shown
                it {should have_content('error')}
            end
        end

        describe "with valid information" do
            before do
                fill_in "Name",             with: "Example User"
                fill_in "Email",            with: "user@example.com"
                fill_in "Password",         with: "test_password"
                fill_in "Confirm Password", with: "test_password"
            end

            it "should create a user" do
                expect {click_button submit}.to change(User, :count).by(1)
            end
            
            # Check redirected to the profile page
            describe "after saving the user" do
                before {click_button submit}
                let(:user) {User.find_by(email: 'user@example.com')}
                
                it {should have_link('Sign out')}
                it {should have_title("Sabaton")}
                it {should have_selector('div.alert.alert-success', text: 'Welcome')}
            end
        end
    end

    # describe "profile page" do
        # let(:user) {FactoryGirl.create(:user)}
        # let!(:topic1) {FactoryGirl.create(:aspect_topic, user: user, content: "Topic 1")}
        # let!(:topic2) {FactoryGirl.create(:aspect_topic, user: user, content: "Topic 2")}
#         
        # before {visit user_path(user)}
#         
        # it {should have_content(user.name)}
        # it {should have_title(user.name)}
#         
        # describe "topics" do
            # it {should have_content(topic1.content)}
            # it {should have_content(topic2.content)}
            # it {should have_content(user.aspect_topics.count)}
        # end
#         
        # describe "deleting an owned topic" do
            # before do
                # sign_in user
                # visit user_path(user)
            # end
#             
            # it "should delete a topic" do
                # within(".topics li##{topic1.id}") do
                    # expect{click_link "delete"}.to change(AspectTopic, :count).by(-1)
                # end
            # end
        # end        
    # end
    
    describe "edit" do
        
        let(:user) {FactoryGirl.create(:user)}
        before do
            sign_in user
            visit edit_user_path(user)
        end
        describe "page" do
            it {should have_content("Update Profile")}
            it {should have_title("Edit User")}
            it {should have_link('Change', href: 'http://gravatar.com/emails')}
        end
        
        describe "with invalid information" do
            before {click_button "Save changes"}
            it {should have_content('error')}
        end
        
        describe "with valid information" do
            let(:new_name)  {"New Name"}
            let(:new_email) {"new@example.com"}
            let(:old_remember_token) {user.remember_token}
            before do
                fill_in "Name", with: new_name
                fill_in "Email", with: new_email
                fill_in "Password", with: user.password
                fill_in "Confirm Password", with: user.password
                click_button "Save changes"
            end
    
            it {should have_title("Sabaton")}
            it {should have_selector('div.alert.alert-success')}
            it {should have_link('Sign out', href: signout_path)}
            specify {expect(user.reload.name).to  eq new_name}
            specify {expect(user.reload.email).to eq new_email}
            specify {expect(user.reload.remember_token).to_not eq :old_remember_token}
        end
    end
end