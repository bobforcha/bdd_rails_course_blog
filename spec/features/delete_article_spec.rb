require 'rails_helper'

RSpec.feature "Deleting an Article" do
  let!(:john) { User.create(email: "john@example.com", password: "password") }
  let!(:article) { Article.create(title: "Title One", body: "Body of article one", user: john) }

  before do
    login_as john
  end

  scenario "A user deletes an article" do
    visit root_path

    click_link article.title
    click_link "Delete Article"

    expect(page).to have_content("Article has been deleted")
    expect(current_path).to eq(articles_path)
  end
end
