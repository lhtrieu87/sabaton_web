require 'spec_helper'

describe "Authentication" do

    subject {page}

    describe "signin page" do
        before {visit signin_path}

        describe "with invalid information" do
            before {click_button "Sign in"}

            it {should have_title('Sign In')}
            it {should have_selector('div.alert.alert-error', text: 'Invalid')}

            describe "after visiting another page" do
                before {click_link "Home"}
                it {should_not have_selector('div.alert.alert-error')}
            end
        end

        describe "with valid information" do
            let(:user) {FactoryGirl.create(:user)}
            before do
                fill_in "Email",    with: user.email
                fill_in "Password", with: user.password
                click_button "Sign in"
            end

            it {should have_title("Sabaton") }
            it {should have_link('Settings', href: edit_user_path(user))}
            it {should have_link('Sign out', href: signout_path)}
            it {should_not have_link('Sign in', href: signin_path)}
            it {should have_selector('div.alert.alert-success')}

            describe "followed by signout" do
                before {click_link "Sign out"}
                it {should have_link('Sign In')}
            end
        end
    end
    
    describe "authorization" do
        describe "for non-signed-in users" do
            let(:user) {FactoryGirl.create(:user)}
            
            describe "in the AspectTopics controller" do
                describe "submitting to the create action" do
                    before {post aspect_topics_path}
                    specify {expect(response).to redirect_to(signin_path)}
                end
                
                describe "submitting to the delete action" do
                    before {delete aspect_topic_path(FactoryGirl.create(:aspect_topic))}
                    specify {expect(response).to redirect_to(signin_path)}
                end
            end
            
            describe "in the Users controller" do
                
                describe "visiting the edit page" do
                    before {visit edit_user_path(user)}
                    # Non-signed in user is not authorized to view user edit page.
                    it {should have_title('Sign In')}
                end

                describe "submitting to the update action" do
                    before {patch user_path(user)}
                    # Non-signed in user is not authorized to update user's profile.
                    specify {expect(response).to redirect_to(signin_path)}
                end
            end
        end
        
        describe "as wrong user" do
            let(:user) {FactoryGirl.create(:user)}
            let(:wrong_user) {FactoryGirl.create(:user, email: "wrong@example.com")}
            before {sign_in user, no_capybara: true}
            
            describe "visiting Users#edit page" do
                before {visit edit_user_path(wrong_user)}
                it {should_not have_title(full_title('Edit user'))}
            end
        
            describe "submitting a PATCH request to the Users#update action" do
                before {patch user_path(wrong_user)}
                specify {expect(response).to redirect_to(root_url)}
            end
            
            describe "delete another user's topic" do
                let!(:topic) {FactoryGirl.create(:aspect_topic, user: wrong_user)}
                
                specify "the topic should not be destroyed" do
                    expect{delete aspect_topic_path(:topic)}.not_to change(AspectTopic, :count).by(-1)
                end
                
                describe "redirected back to the root_path" do
                    before {delete aspect_topic_path(:topic)}
                    specify {expect(response).to redirect_to(root_url)}
                end
            end
        end
    end
end
