# spec/requests/searches_spec.rb
require 'rails_helper'

RSpec.describe "Searches", type: :request do
  before do
    # Token csrf config
    allow_any_instance_of(ApplicationController).to receive(:verify_authenticity_token)
    post give_consent_path
  end

  describe "POST /pages/save_query" do
    context "with a valid query" do
      let(:valid_params) { { query: "my final search" } }

      it "creates a new SearchAnalytic record" do
        expect {
          post pages_save_query_path, params: valid_params
        }.to change(SearchAnalytic, :count).by(1)
      end

      it "saves the correct query and IP address" do
        post pages_save_query_path, params: valid_params
        
        created_analytic = SearchAnalytic.last
        expect(created_analytic.query).to eq("my final search")
        expect(created_analytic.user_ip).to eq(request.remote_ip)
      end

      it "returns an http status :ok (200)" do
        post pages_save_query_path, params: valid_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with a blank query" do
      let(:invalid_params) { { query: "" } }

      it "does not create a new SearchAnalytic record" do
        expect {
          post pages_save_query_path, params: invalid_params
        }.not_to change(SearchAnalytic, :count)
      end

      it "returns an http status :ok (200)" do
        post pages_save_query_path, params: invalid_params
        expect(response).to have_http_status(:ok)
      end
    end
  end
end