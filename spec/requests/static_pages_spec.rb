require 'spec_helper'
include ActionView::Helpers::DateHelper

describe 'Static pages' do
    subject {page}
    describe 'forum page' do

        let(:user1) {FactoryGirl.create(:user, name: "user1", email: 'sample1@sample1.com')}
        let(:user2) {FactoryGirl.create(:user, name: "user2", email: 'sample2@sample2.com')}
        let!(:topic1) {FactoryGirl.create(:aspect_topic, user: user1, content: "Topic 1")}
        let!(:topic2) {FactoryGirl.create(:aspect_topic, user: user2, content: "Topic 2")}
        
        before {visit forum_path}
        
        describe "with correct path" do
            it {should have_title 'Aspects Forum'}
            it {should have_content 'Aspects Forum'}
        end
        
        describe 'with no signed in user' do
            it "does not display topic creation form" do 
                should_not have_selector 'form#new_aspect_topic'
            end
            
            it "does not render comment creation form" do
                should_not have_selector '.comment-post-form'
            end
        end

        describe 'with a signed in user' do
            before do
                sign_in(user1)
                visit forum_path
            end
            it {should have_selector '#current-user'}
            it "displaying signed in user's name & email & create topic form" do
                within('#current-user') do
                    should have_content user1.name
                    should have_content user1.email
                end
                should have_selector 'form#new_aspect_topic'
            end
            
            describe "topic creation" do
                describe "with invalid information" do
                    it "should not create a new topic" do
                        expect {click_button "Create"}.not_to change(AspectTopic, :count)
                    end
                    
                    describe "error messages" do
                        before {click_button "Create"}
                        it {should have_content 'error'}
                        it {should have_content 'Aspects Forum'}
                    end
                end
                
                describe "with valid information" do
                    before do
                        fill_in "aspect_topic_content", with: Faker::Lorem.sentence(20)
                    end
                    
                    it "should create a new topic" do
                        expect {click_button "Create"}.to change(AspectTopic, :count).by(1)
                    end
                    
                    describe "successful message" do
                        before {click_button "Create"}
                        it {should have_selector('div.alert.alert-success')}
                        it {should have_content 'Aspects Forum'}
                    end
                end
            end
            
            describe "topic destruction" do
                
                describe "as owning user" do
                    it "should delete a topic" do
                        within(".topics li##{topic1.id}") do
                            expect{click_link "Delete"}.to change(AspectTopic, :count).by(-1)
                        end
                    end
                end
            end
            
            it "displaying comment creation form(s)" do
                within(".topics li##{topic1.id}") do
                    should have_selector '.comment-post-form'    
                end
                within(".topics li##{topic2.id}") do
                    should have_selector '.comment-post-form'    
                end
            end
        end
        
        describe 'displays all topics' do
            it {should have_selector("li##{topic1.id}", text: topic1.content)}
            it {should have_selector("li##{topic2.id}", text: topic2.content)}
            it {should have_content(AspectTopic.all.count)}
        end
        
        describe 'only shows delete link for those links created by the currently signed in user' do
            before do
                sign_in(user1)
                visit forum_path
            end
            it {should have_selector("li##{topic1.id} a", text: "Delete")}
            it {should_not have_selector("li##{topic2.id} a", text: "Delete")}
        end
        
        describe "displays comment(s) for topic(s)" do
            let!(:comment1) {FactoryGirl.create(:comment, user: user1, aspect_topic: topic1, content: Faker::Lorem.sentence(20), created_at: 1.hour.ago)}
            let!(:comment2) {FactoryGirl.create(:comment, user: user2, aspect_topic: topic1, content: Faker::Lorem.sentence(20), created_at: 1.day.ago)}
            
            before {visit forum_path}
            
            it do
                within("li##{topic1.id}") do
                    should have_content '2 comments'
                    
                    should have_content user1.name
                    should have_content comment1.content
                    should have_content time_ago_in_words(comment1.created_at)
                    should have_selector("img[alt='#{user1.name}']")
                    
                    should have_content user2.name
                    should have_content comment2.content
                    should have_content time_ago_in_words(comment2.created_at)    
                    should have_selector("img[alt='#{user2.name}']")
                end
            end
        end
        
        describe "the topic only has one comment" do
            let!(:comment3) {FactoryGirl.create(:comment, user: user2, aspect_topic: topic2, content: Faker::Lorem.sentence(20), created_at: 1.day.ago)}
            before {visit forum_path}
            it "should display text of '1 comment'" do
                within("li##{topic2.id}") do
                    p topic2.comments.count
                    should have_content '1 comment'
                end
            end
        end
    end
end

