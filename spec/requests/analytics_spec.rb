require 'rails_helper'

RSpec.describe "Analytics", type: :request do
  before do
    # Token csrf config
    allow_any_instance_of(ApplicationController).to receive(:verify_authenticity_token)
    post give_consent_path
  end

  describe "GET /analytics/global" do
    it "renders the page successfully" do
      create(:search_analytic, query: "super clever query", user_ip: "1.1.1.1")
      get global_analytics_path
      
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Global Search Analytics")
      expect(response.body).to include("super clever query")
    end
  end

  describe "GET /analytics/user" do
    it "renders the user analytics page successfully and filters by IP" do
      create(:search_analytic, query: "my personal query", user_ip: "127.0.0.1")
      create(:search_analytic, query: "other user query", user_ip: "2.2.2.2")
      
      get user_analytics_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("My Personal Analytics")
      expect(response.body).to include("my personal query")
      expect(response.body).not_to include("other user query")
    end
  end
end