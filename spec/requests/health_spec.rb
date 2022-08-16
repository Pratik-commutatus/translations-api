require 'rails_helper'

RSpec.describe "Healths", type: :request do
  context "tests the status of the API" do
    before { get "/health/index" }

    it "returns an 'online' status" do
      expect(response.body).to eq('{"status":"online"}')
    end
      
    it "returns http success" do
      expect(response.status).to eq(200)
    end
  end
end