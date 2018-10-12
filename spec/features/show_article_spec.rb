require 'rails_helper'

RSpec.feature "Showing an article" do
  let!(:john)     { User.create(email: "john@example.com", password: "password") }
  let!(:fred)     { User.create(email: "fred@example.com", password: "password") }
  let!(:article)  { Article.create(title: "Title One", body: "Body of article one", user: john) }

  context "when user is not signed in" do
    before do
      visit root_path
      click_link(article.title)
    end

    it "hides the edit and delete buttons" do
      expect(page).to have_content(article.title)
      expect(page).to have_content(article.body)
      expect(current_path).to eq(article_path(article))
      expect(page).not_to have_link("Edit Article")
      expect(page).not_to have_link("Delete Article")
    end
  end

  context "when user is signed in" do
    context "and is not the article owner" do
      before do
        login_as fred
        visit root_path
        click_link(article.title)
      end

      it "hides the edit and delete buttons" do
        expect(page).to have_content(article.title)
        expect(page).to have_content(article.body)
        expect(current_path).to eq(article_path(article))
        expect(page).not_to have_link("Edit Article")
        expect(page).not_to have_link("Delete Article")
      end
    end

    context "and is the article owner" do
      before do
        login_as john
        visit root_path
        click_link(article.title)
      end

      it "shows the edit and delete buttons" do
        expect(page).to have_content(article.title)
        expect(page).to have_content(article.body)
        expect(current_path).to eq(article_path(article))
        expect(page).to have_link("Edit Article")
        expect(page).to have_link("Delete Article")
      end
    end
  end
end
