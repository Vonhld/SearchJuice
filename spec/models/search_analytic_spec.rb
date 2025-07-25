require 'rails_helper'

RSpec.describe SearchAnalytic, type: :model do

  let!(:user_analytic_1) { create(:search_analytic) }
  let!(:user_analytic_2) { create(:search_analytic, user_ip: '192.168.1.1') }

  describe "scopes" do
    describe ".for_user" do
      it "returns only the records for the specified IP address" do

        result = SearchAnalytic.for_user(user_analytic_1.user_ip)

        expect(result).to include(user_analytic_1)
        expect(result.count).to eq(1)
      end
    end
  end
end