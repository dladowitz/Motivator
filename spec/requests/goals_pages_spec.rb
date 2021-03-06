#TODO move to views folder when we figure out why this file doesn't work from there
require 'spec_helper'

describe "Goals pages" do
  subject { page }
  let(:user) { Fabricate(:user) }
  let(:goal) { Fabricate(:goal_with_pledge_and_objective) }


  describe "goals#index" do

    describe "when logged out" do
      before { visit goals_path }
      it { should have_content('public goals') }
    end # when logged out

    describe "when logged in" do
      before do
        visit new_user_session_path
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Sign in"
        goal = user.goals.create(:description => "Have fun", :due_date => Time.now + 3.weeks, :user_id => user.id)
        goal.objectives.create(:description => "have more fun", :frequency => 3)
        visit goals_path
      end

      it {should have_content("Create a New Goal")}
      it {should have_content("Here are your existing goals")}
      it "should list the goals" do
        user.goals.each do |goal|
          page.should have_content(goal.description)
        end
      end
    end
  end

  describe "goals#edit" do

    describe "when logged out" do
      before { visit goal_path(goal) }
      it { should have_content('Sign in') }
    end # when logged out

    describe "when logged in" do
      before do
        visit new_user_session_path
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Sign in"
        visit edit_goal_path(goal)
      end

      it { should have_content(goal.description) }
      it { should have_content('When did you') }
      it { should have_content("#{goal.readable_date}") }

      describe "mark things done" do
        before do
          find(:css, "#day_1").set(true)
        end

        it "should save the step" do
          expect { click_link_or_button "Mark 'em done!" }.to change(Step, :count).by(1)
        end

        it "should redirect to the show page" do
          click_link_or_button "Mark 'em done!"
          page.should have_content(goal.description)
        end
      end

    end # when logged in
  end # goals#edit
end
