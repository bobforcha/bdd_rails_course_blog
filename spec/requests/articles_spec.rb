require 'rails_helper'

RSpec.describe "Articles", type: :request do
  let!(:john)     { User.create(email: "john@example.com", password: "password") }
  let!(:fred)     { User.create(email: "fred@example.com", password: "password") }
  let!(:article)  { Article.create(title: "Title One", body: "Body of article one.", user: john) }

  describe "GET /articles/:id" do
    context "with existing article" do
      before { get "/articles/#{article.id}" }

      it "handles existing article" do
        expect(response.status).to eq 200
      end
    end

    context "with non-existent article" do
      before { get "/articles/xxxx" }

      it "handles non-existent article" do
        expect(response.status).to eq 302
        flash_message = "The article you're looking for couldn't be found"
        expect(flash[:alert]).to eq flash_message
      end
    end
  end

  describe "GET /articles/:id/edit" do
    context "when user is not signed in" do
      before { get "/articles/#{article.id}/edit" }

      it "redirects to the sign-in page" do
        expect(response.status).to eq 302
        flash_message = "You need to sign in or sign up before continuing."
        expect(flash[:alert]).to eq flash_message
      end
    end

    context "when user is signed in" do
      context "and is not the article's owner" do
        before do
          login_as fred
          get "/articles/#{article.id}/edit"
        end

        it "redirects to the home page" do
          expect(response.status).to eq 302
          flash_message = "You can only edit your own articles."
          expect(flash[:alert]).to eq flash_message
        end
      end

      context "and is the article's owner" do
        before do
          login_as john
          get "/articles/#{article.id}/edit"
        end

        it "renders the edit form" do
          expect(response.status).to eq 200
        end
      end
    end
  end

  describe "DELETE /articles/:id" do
    context "when user is not signed in" do
      before { delete "/articles/#{article.id}" }

      it "redirects to the sign-in page" do
        expect(response).to redirect_to new_user_session_path
        expect(response.status).to eq 302
        flash_message = "You need to sign in or sign up before continuing."
        expect(flash[:alert]).to eq flash_message
      end
    end

    context "when user is signed in" do
      context "and is not the article's owner" do
        before do
          login_as fred
          delete "/articles/#{article.id}"
        end

        it "redirects to the home page" do
          expect(response).to redirect_to root_path
          expect(response.status).to eq 302
          flash_message = "You can only delete your own articles."
          expect(flash[:alert]).to eq flash_message
        end
      end

      context "and is the article's owner" do
        before do
          login_as john
          delete "/articles/#{article.id}"
        end

        it "redirects to the articles path after successful delete" do
          expect(response).to redirect_to articles_path
          expect(response.status).to eq 302
          flash_message = "Article has been deleted."
          expect(flash[:alert]).to eq flash_message
        end
      end
    end
  end
end
