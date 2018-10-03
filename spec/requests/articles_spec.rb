require 'rails_helper'

RSpec.describe "Articles", type: :request do
  let!(:article) { Article.create(title: "Title One", body: "Body of article one.") }

  describe "GET /articles/:id" do
    context "with existing article" do
      before { get "/articles/#{article.id}" }

      it "handles existing article" do
        expect(response.status).to eq 200
      end
    end

    context "witjh non-existent article" do
      before { get "/articles/xxxx" }

      it "handles non-existent article" do
        expect(response.status).to eq 302
        flash_message = "The article you're looking for couldn't be found"
        expect(flash[:alert]).to eq flash_message
      end
    end
  end
end
