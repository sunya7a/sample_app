require 'spec_helper'

describe Micropost do

    let(:user) { FactoryGirl.create(:user) }
    before { @micropost = user.microposts.build(content: "Lorem ipsum") }

    subject { @micropost }

    it { should respond_to(:content) }
    it { should respond_to(:user_id) }
    it { should respond_to(:user) }
    its(:user) { should == user }

    it { should be_valid }

    describe "accessible attributes" do
        it "should not allow access to user_id" do
            expect do
                Micropost.new(user_id: user.id)
            end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
        end
    end

    describe "when user_id is not present" do
        before { @micropost.user_id = nil }
        it { should_not be_valid }
    end

    describe "when user_id is not present" do
        before { @micropost.user_id = nil }
        it { should_not be_valid }
    end

    describe "with blank content" do
        before { @micropost.content = " " }
        it { should_not be_valid }
    end

    describe "with content that is too long" do
        before { @micropost.content = "a" * 141 }
        it { should_not be_valid }
    end

    describe "profile page" do
        let(:user) { FactoryGirl.create(:user) }
        let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
        let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }

        before { visit user_path(user) }

        it { should have_selector('h1',    text: user.name) }
        it { should have_selector('title', text: user.name) }

        describe "microposts" do
            it { should have_content(m1.content) }
            it { should have_content(m2.content) }
            it { should have_content(user.microposts.count) }
        end
    end
end
