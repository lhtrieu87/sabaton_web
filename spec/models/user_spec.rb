require 'spec_helper'

describe User do
    before do
        @user = User.new(name: "Example User", email: "user@example.com",
                         password: "foobar", password_confirmation: "foobar")
    end

    subject {@user}

    it {should respond_to(:name)}
    it {should respond_to(:email)}
    it {should respond_to(:password_digest)}
    it {should respond_to(:password)}
    it {should respond_to(:password_confirmation)}
    it {should respond_to(:authenticate)}
    it {should respond_to(:remember_token)}
    it {should respond_to(:aspect_topics)}
    it {should respond_to(:comments)}

    it {should be_valid}

    describe "when name is not present" do
        before {@user.name = " "}
        it {should_not be_valid}
    end

    describe "when email is not present" do
        before {@user.email = " "}
        it {should_not be_valid}
    end

    describe "when name is too long" do
        before {@user.name = "a" * 51}
        it {should_not be_valid}
    end

    describe "when email format is invalid" do
        it "should be invalid" do
            addresses = %w[user@foo,com user_at_foo.org example.user@foo.
            foo@bar_baz.com foo@bar+baz.com]
            addresses.each do |invalid_address|
                @user.email = invalid_address
                expect(@user).not_to be_valid
            end
        end
    end

    describe "when email format is valid" do
        it "should be valid" do
            addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
            addresses.each do |valid_address|
                @user.email = valid_address
                expect(@user).to be_valid
            end
        end
    end

    describe "when email address is already taken" do
        before do
            user_with_same_email = @user.dup
            user_with_same_email.email = @user.email.upcase
            user_with_same_email.save
        end

        it {should_not be_valid}
    end

    describe "email address with mixed case" do
        let(:mixed_case_email) {"Foo@ExAMPle.CoM"}

        it "should be saved as all lower-case" do
            @user.email = mixed_case_email
            @user.save
            expect(@user.reload.email).to eq mixed_case_email.downcase
        end
    end

    describe "when password is not present" do
        before do
            @user = User.new(name: "Example User", email: "user@example.com",
                     password: " ", password_confirmation: " ")
        end
        it {should_not be_valid}
    end

    describe "when password doesn't match confirmation" do
        before {@user.password_confirmation = "mismatch"}
        it {should_not be_valid}
    end

    describe "return value of authenticate method" do
        before {@user.save}
        let(:found_user) {User.find_by(email: @user.email)}

        describe "with valid password" do
            it {should eq found_user.authenticate(@user.password)}
        end

        describe "with invalid password" do
            let(:user_for_invalid_password) {found_user.authenticate("invalid")}

            it {should_not eq user_for_invalid_password}
            specify {expect(user_for_invalid_password).to be_false}
        end
    end

    describe "with a password that's too short" do
        before {@user.password = @user.password_confirmation = "a" * 5}
        it {should be_invalid}
    end

    describe "remember token" do
        before {@user.save}
        its(:remember_token) {should_not be_blank}
    end

    describe "aspect_topic associations" do

        before {@user.save}
        let!(:older_topic) do
            FactoryGirl.create(:aspect_topic, user: @user, created_at: 1.day.ago)
        end
        let!(:newer_topic) do
            FactoryGirl.create(:aspect_topic, user: @user, created_at: 1.hour.ago)
        end

        it "should have the right aspect topics in the right order" do
            topics = @user.aspect_topics.to_a
            expect(topics).to eq [newer_topic, older_topic]
        end

        it "should destroy associated aspect topics" do
            topics = @user.aspect_topics.to_a
            @user.destroy
            expect(topics).not_to be_empty
            topics.each do |topic|
                expect(AspectTopic.where(id: topic.id)).to be_empty
            end
        end
    end
    
    describe "comment associations" do
        let(:me) {FactoryGirl.create(:user)}
        let(:his_topic) {FactoryGirl.create(:aspect_topic, user: @user)}
        let(:my_topic) {FactoryGirl.create(:aspect_topic, user: me)}
        before {@user.save}
        
        describe "I comment his topic" do
            let(:my_comment) {me.comments.build(aspect_topic_id: his_topic.id, content: Faker::Lorem.sentence(20))}
            specify {expect(my_comment).to be_valid}
        end
        
        describe "I comment my topic" do
            let(:my_comment) {me.comments.build(aspect_topic: my_topic, content: Faker::Lorem.sentence(20))}
            specify {expect(my_comment).to be_valid}
        end
        
        let!(:new_comment) {FactoryGirl.create(:comment, user: me, aspect_topic: his_topic, content: Faker::Lorem.sentence(20), created_at: 1.hour.ago)}
        let!(:old_comment) {FactoryGirl.create(:comment, user: me, aspect_topic: his_topic, content: Faker::Lorem.sentence(20), created_at: 1.day.ago)}
        
        it "should have comments appearing in time ascending order" do
            comments = me.comments.where(aspect_topic_id: his_topic.id).to_a
            expect(comments).to eq [old_comment, new_comment]
        end
        
        it "should destroy all associated comments" do
            comments = me.comments.to_a
            me.destroy
            expect(comments).not_to be_empty
            comments.each do |comment|
                expect(Comment.where(id: comment.id)).to be_empty
            end
        end
    end
end
