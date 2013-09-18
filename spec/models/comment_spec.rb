require 'spec_helper'

describe Comment do
    let(:user) {FactoryGirl.create(:user)}
    let(:topic) {FactoryGirl.create(:aspect_topic, user: user)}
    before do
        @comment = user.comments.build(aspect_topic_id: topic.id, content: Faker::Lorem.sentence(20))
        @another_comment = topic.comments.build(user_id: user.id, content: Faker::Lorem.sentence(20))
    end
    
    subject {@comment}
    
    it {should respond_to :user_id}
    it {should respond_to :aspect_topic_id}
    it {should respond_to :content}
    its(:user) {should eq user}
    its(:aspect_topic) {should eq topic}
    
    it {should be_valid}
    
    describe "when user_id is not present" do
        before {@comment.user_id = nil}
        it {should_not be_valid}
    end
    
    describe "when topic_id is not present" do
        before {@comment.aspect_topic_id = nil}
        it {should_not be_valid}
    end
    
    describe "when content is empty" do
        before {@comment.content = " "}
        it {should_not be_valid}
    end
    
    describe "when content is too long" do
        before {@comment.content = "a" * 251}
        it {should_not be_valid}
    end
end
