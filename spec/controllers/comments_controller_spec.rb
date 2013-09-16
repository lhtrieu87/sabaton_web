require 'spec_helper'

describe CommentsController do
    describe "for non-signed-in users" do
        describe "submitting to the create action" do
            before {post 'create'}
            specify {expect(response).to redirect_to(signin_path)}
        end

        # describe "submitting to the destroy action" do
            # before {delete comment_path(FactoryGirl.create(:comment))}
            # specify {expect(response).to redirect_to(signin_path)}
        # end
    end
    
    describe "create action" do
        let(:me) {FactoryGirl.create(:user, email: "me@me.com", password: "123456", password_confirmation: "123456")}
        let(:user) {FactoryGirl.create(:user, email: "user@user.com", password: "123456", password_confirmation: "123456")}
        
        let(:my_topic) {FactoryGirl.create(:aspect_topic, user: me)}
        let(:user_topic) {FactoryGirl.create(:aspect_topic, user: user)}
        
        describe "I can comment my topic" do
            let(:content) {Faker::Lorem.sentence(20)}
            before do
                sign_in me, no_capybara: true
                xhr :post, :create, :comment => {:aspect_topic_id => my_topic.id, :content => content}
            end
            
            subject {Comment.last}
            its(:aspect_topic_id) {should eq my_topic.id}
            its(:user_id) {should eq me.id}
            its(:content) {should eq content}
            it "should respond with success" do
                expect(response).to be_success      
            end      
        end
        
        describe "I can comment other user's topic" do
            let(:content) {Faker::Lorem.sentence(20)}
            before do
                sign_in me, no_capybara: true
                xhr :post, :create, :comment => {:aspect_topic_id => user_topic.id, :content => content}
            end            
            
            subject {Comment.last}
            its(:aspect_topic_id) {should eq user_topic.id}
            its(:user_id) {should eq me.id}
            its(:content) {should eq content}
            
            it "should respond with success" do
                expect(response).to be_success      
            end 
        end
    end
end
