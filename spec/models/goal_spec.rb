require 'spec_helper'

describe Goal do
  before { @goal = Fabricate(:goal) }
  subject { @goal }

  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:due_date) }
  it { should validate_presence_of(:user_id) }
  it { should respond_to(:due_date) }
  it { should respond_to(:description) }
  it { should belong_to(:user) }
  it { should have_many(:objectives)}
  it { should have_many(:steps).through(:objectives) }

  it "throws an error if a goal doesn't have a user, description, or due date" do
    expect { Goal.create }.should raise_error
  end

  it "creates a goal with a user, description, and due date" do
    Goal.create(:user_id => 1, :due_date => Time.now + 6.months, :description => "go to the gym").should be_valid
  end

  describe "progress methods" do

    before :each do
      @started_date = Time.now - 2.months
      @due_date = Time.now + 2.months
      @goal = Goal.create(:user_id => 1, :due_date => @due_date, :description => "Become a Black Belt")
      @goal.objectives.create(:description => "Go to Karate Class", :frequency => 3)
    end

    it "should be able to calculate current Goal progress as a percentage" do
      4.times do
        @goal.objectives.last.steps.create(:completed_at => Time.now)
      end
      @goal.percentage_complete.should eq 15
    end

    it "calculates the expected progress as a percentage based on the current date" do
      goal_2 = Goal.create(:created_at => @started_date, :user_id => 1, :description => "become a yellow belt", :due_date => @due_date)
      goal_2.objectives.create(:description => "Go to Karate Class", :frequency => 3)
      22.times do
        goal.objectives.last.steps.create(:completed_at => Time.now)
      end
      goal_2.expected_percentage_complete.should eq 50
    end

  end

end

