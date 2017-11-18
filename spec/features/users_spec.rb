require "rails_helper"

feature "Users" do
  scenario "Non-admin tries to view users list" do
    user = create(:user)
    login_as(user)
    visit users_path
    expect(page).to have_current_path(root_path)
    expect(page).to have_content("Access denied, admin only")
  end

  scenario "Admin tries to view users list" do
    admin = create(:admin)
    login_as(admin)
    visit users_path
    expect(page).to have_current_path(users_path)
  end
end

feature "Sign up and confirm", :admin do
  include ActiveJob::TestHelper

  scenario "Happy path" do
    user = build(:user)
    perform_enqueued_jobs do
      register_account(user)
      confirm_account(user)
    end
    sign_in(user)
    verify_sample_radar_presence
  end

  def register_account(user)
    visit new_user_registration_path
    fill_in "Name", with: user.name
    fill_in "Email", with: user.email
    fill_in "user_password", with: user.password
    fill_in "user_password_confirmation", with: user.password
    fill_in "user_username", with: user.username
    click_button "Sign up"
    expect(page).to have_content("Please open the link to activate your account")
  end

  def confirm_account(user)
    open_email(user.email)
    raise "No mail" unless current_email
    current_email.click_link "Confirm my account"
  end

  def sign_in(user)
    visit new_user_session_path
    fill_in "Username", with: user.username
    fill_in "user_password", with: user.password
    click_button "Sign in"
    expect(page).to have_content("Signed in successfully")
    expect(page).to have_current_path(new_bulk_topic_path)
  end

  def verify_sample_radar_presence
    visit radars_path
    expect(page).to have_css(".radars", text: "Personal Radar")
    radar_name = User.last.radars.first.name
    click_link radar_name
    expect(page).to have_css("h1", text: radar_name)
  end
end
