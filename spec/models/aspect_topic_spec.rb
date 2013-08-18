require 'spec_helper'

describe AspectTopic do

    let(:user) {FactoryGirl.create(:user)}
    before do
        # This code is not idiomatically correct.
        @topic = AspectTopic.new(content: "Lorem ipsum", user_id: user.id)
    end

    subject {@topic}

    it {should respond_to(:content)}
    it {should respond_to(:user_id)}
end
