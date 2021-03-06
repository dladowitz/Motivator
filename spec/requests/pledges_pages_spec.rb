require 'spec_helper'

describe "Pledge pages" do
  subject { page }
  let(:user) { Fabricate(:user) }
  let(:goal) { Fabricate(:goal_with_objective) }

  describe "pledge#new" do

    describe "when logged out" do
      before { visit new_goal_pledge_path(goal) }
      it { should have_content('Sign in') }
    end # when logged out


    describe "when logged in and yes goal" do
      before do
        visit new_user_session_path
        fill_in "Email", :with => user.email
        fill_in "Password", :with => user.password
        click_button "Sign in"
        visit new_goal_path
        fill_in "goal[description]", :with => goal.description
        fill_in "goal[due_date]", :with => goal.due_date
        fill_in "goal[objectives_attributes][0][description]", :with => goal.objectives.first.description
        # fill_in "goal[objectives_attributes][0][frequency]", :with => goal.objectives.first.frequency
        select("3", :from => "goal_objectives_attributes_0_frequency")
        click_button "I'm ready to get motivated"
      end

      it { should have_content('pledge') }
      it { should have_content('Suggested pledges based on your time horizon')}

      describe "filling in a pledge" do
        it "saves a pledge amount" do
          fill_in "pledge[amount]", :with => 20
          expect { click_button "Submit my pledge" }.to change(Pledge, :count).by(1)
        end
      end
    end
  end
end