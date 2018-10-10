require 'rails_helper'

RSpec.feature "Showing an article" do
  let!(:john) { User.create(email: "john@example.com", password: "password") }
  let!(:article) { Article.create(title: "Title One", body: "Body of article one", user: john) }

  before do
    login_as john
  end

  scenario "A user shows an article" do
    visit root_path
    click_link(article.title)

    expect(page).to have_content(article.title)
    expect(page).to have_content(article.body)
    expect(current_path).to eq(article_path(article))
  end
end
