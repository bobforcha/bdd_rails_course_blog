require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let!(:john)     { User.create(email: "john@example.com", password: "password") }
  let!(:fred)     { User.create(email: "fred@example.com", password: "password") }
  let!(:article)  { Article.create(title: "Title One", body: "Body of article one.", user: john) }

  describe "POST /articles/:id/comments" do
    context "when user is not signed in" do
      before do
        post "/articles/#{article.id}/comments", params: {comment: {body: "Awesome blog"}}
      end

      it "redirects the user to the sign-in page" do
        flash_message = "Please sign in or sign up first"

        expect(response).to redirect_to(new_user_session_path)
        expect(response.status).to eq 302
        expect(flash[:alert]).to eq flash_message
      end
    end

    context "when user is signed in" do
      before do
        login_as fred
        post "/articles/#{article.id}/comments", params: {comment: {body: "Awesome blog"}}
      end

      it "creates the comment successfully" do
        flash_message = "Comment has been created"

        expect(response).to redirect_to(article_path(article.id))
        expect(response.status).to eq 302
        expect(flash[:alert]).to eq flash_message
      end
    end
  end
end
