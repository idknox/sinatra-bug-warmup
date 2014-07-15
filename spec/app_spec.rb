require "spec_helper"

feature "User can log in" do
  scenario "user can log into their account" do

    visit "/"

    click_link("Register")

    fill_in("username", :with => "Hunter")
    fill_in("email", :with => "hunter@example.com")
    fill_in("password", :with => "123")
    check("name_is_hunter")
    click_button("Register")

    fill_in("username", :with => "Hunter")
    fill_in("username", :with => "Hunter")
    click_button("Login")

    expect(page).to have_content("Welcome, Hunter")
  end
end