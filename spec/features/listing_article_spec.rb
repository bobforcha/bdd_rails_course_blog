require 'rails_helper'

RSpec.feature "Listing Articles" do
  let!(:article1) { Article.create(title: "The first article", body: "Lorem ipsum dolor sit amet, consectetur.") }
  let!(:article2) { Article.create(title: "The second article", body: "Body of 2nd article") }

  scenario "A user lists all articles" do
    visit root_path
    expect(page).to have_content(article1.title)
    expect(page).to have_content(article1.body)
    expect(page).to have_content(article2.title)
    expect(page).to have_content(article2.body)
    expect(page).to have_link(article1.title)
    expect(page).to have_link(article2.title)
  end
end
