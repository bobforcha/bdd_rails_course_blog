require 'rails_helper'

RSpec.feature "Adding reviews to articles" do
  let!(:john)     { User.create(email: "john@example.com", password: "password") }
  let!(:fred)     { User.create(email: "fred@example.com", password: "password") }
  let!(:article)  { Article.create(title: "Title One", body: "Body of article one", user: john) }

  scenario "permits a signed in user to write a rewview" do
    login_as fred
    visit root_path
    click_link article.title
    fill_in "New Comment", with: "An amazing article"
    click_button "Add Comment"

    expect(page).to have_content "Comment has been created"
    expect(page).to have_content "An amazing article"
    expect(current_path).to eq article_path(article)
  end
end
