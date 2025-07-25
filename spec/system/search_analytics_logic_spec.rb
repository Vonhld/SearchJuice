require 'rails_helper'

RSpec.describe "Search Analytics Logic", type: :system, js: true do
  before do
    SearchAnalytic.delete_all
    give_ip_consent_ui
  end

  context "when a user types and then stops (inactivity trigger)" do
    it "saves only the most complete query, ignoring the pyramid fragments" do
      visit home_path

      fill_in "Search your articles...", with: "Hello"
      fill_in "Search your articles...", with: "Hello world"
      fill_in "Search your articles...", with: "Hello world how"
      fill_in "Search your articles...", with: "Hello world how are"
      fill_in "Search your articles...", with: "Hello world how are you?"

      sleep 5 # Logic timer is 4s
      
      expect(SearchAnalytic.count).to eq(1)
      expect(SearchAnalytic.last.query).to eq("Hello world how are you?")
    end
  end

  context "when a user types, deletes part of the text, and then stops" do
    it "saves the longest version of the query, even after it was partially deleted" do
      visit home_path

      fill_in "Search your articles...", with: "How is emil hajric doing"
      fill_in "Search your articles...", with: "How is emil hajr"
      
      sleep 5

      expect(SearchAnalytic.count).to eq(1)
      expect(SearchAnalytic.last.query).to eq("How is emil hajric doing")
    end
  end
  
  context "when a user types and then clears the input (clear trigger)" do
    it "saves the most complete query immediately" do
      visit home_path

      fill_in "Search your articles...", with: "What is"
      fill_in "Search your articles...", with: "What is a "
      fill_in "Search your articles...", with: "What is a good car"
      fill_in "Search your articles...", with: ""

      sleep 0.5

      # 4. Check the result
      expect(SearchAnalytic.count).to eq(1)
      expect(SearchAnalytic.last.query).to eq("What is a good car")
    end
  end
end