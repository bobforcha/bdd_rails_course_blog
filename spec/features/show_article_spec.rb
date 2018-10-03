require 'rails_helper'

RSpec.feature "Showing an article" do
  let!(:article) { Article.create(title: "The article", body: "Some stuff") }

  scenario "A user shows an article" do
    visit root_path
    click_link(article.title)

    expect(page).to have_content(article.title)
    expect(page).to have_content(article.body)
    expect(current_path).to eq(article_path(article))
  end
end
