require 'spec_helper'

describe AspectTopic do

    let(:user) {FactoryGirl.create(:user)}
    before do
    # User creates a topic which helps to enforce the topic has valid user_id.
        @topic = user.aspect_topics.build(content: "Lorem ipsum")
    end

    subject {@topic}

    it {should respond_to(:content)}
    it {should respond_to(:user_id)}
    it {should respond_to(:user)}
    its(:user) {should eq user}

    it {should be_valid}

    describe "when user_id is not present" do
        before {@topic.user_id = nil}
        it {should_not be_valid}
    end

    describe "with blank content" do
        before {@topic.content = " "}
        it {should_not be_valid}
    end

    describe "with content that is too long" do
        before {@topic.content = "a" * 251}
        it {should_not be_valid}
    end
    
    describe "displayed in the time descending order" do
        let(:user1) {FactoryGirl.create(:user, email: 'sample1@sample1.com')}
        let(:user2) {FactoryGirl.create(:user, email: 'sample2@sample2.com')}
        let!(:old_topic) {FactoryGirl.create(:aspect_topic, user: user1, content: "Topic 1", created_at: 1.day.ago)}
        let!(:new_topic) {FactoryGirl.create(:aspect_topic, user: user2, content: "Topic 2", created_at: 1.hour.ago)}
        
        specify {expect(AspectTopic.all.to_a).to eq [new_topic, old_topic]}
    end
end
