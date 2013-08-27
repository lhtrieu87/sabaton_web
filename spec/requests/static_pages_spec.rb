require 'spec_helper'

describe 'Static pages' do
    subject {page}
    describe 'forum page' do

        let(:user1) {FactoryGirl.create(:user, email: 'sample1@sample1.com')}
        let(:user2) {FactoryGirl.create(:user, email: 'sample2@sample2.com')}
        let!(:topic1) {FactoryGirl.create(:aspect_topic, user: user1, content: "Topic 1")}
        let!(:topic2) {FactoryGirl.create(:aspect_topic, user: user2, content: "Topic 2")}
        
        before {visit forum_path}
        
        describe "with correct path" do
            it {should have_title 'Aspect Forum'}
            it {should have_content 'Aspect Forum'}
        end
        
        describe 'with no signed in user' do
            it {should_not have_selector 'aside.span5'}
        end

        describe 'with a signed in user' do
            before do
                sign_in(user1)
                visit forum_path
            end
            it {should have_selector 'aside.span5'}
            it "displaying signed in user's name & email & create topic form" do
                within('aside.span5') do
                    should have_content user1.name
                    should have_content user1.email
                    should have_selector 'form#new_aspect_topic'
                end
            end
            
            describe "topic creation" do
                describe "with invalid information" do
                    it "should not create a new topic" do
                        expect {click_button "Create"}.not_to change(AspectTopic, :count)
                    end
                    
                    describe "error messages" do
                        before {click_button "Create"}
                        it {should have_content 'error'}
                        it {should have_content 'Aspect Forum'}
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
                        it {should have_content 'Aspect Forum'}
                    end
                end
            end
            
            describe "topic destruction" do
                
                describe "as owning user" do
                    it "should delete a topic" do
                        within(".topics li##{topic1.id}") do
                            expect{click_link "delete"}.to change(AspectTopic, :count).by(-1)
                        end
                    end
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
            it {should have_selector("li##{topic1.id} a", text: "delete")}
            it {should_not have_selector("li##{topic2.id} a", text: "delete")}
        end
    end
end

