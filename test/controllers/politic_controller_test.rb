require 'test_helper'

class PoliticControllerTest < ActionController::TestCase
 describe "GET #index" do
    it "assigns all pages as @pages" do
      page = Page.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:news)).to eq([page])
    end
  end
end
