require "rails_helper"
require 'pry'

RSpec.describe PlatesController, type: :controller do
  include Devise::Test::ControllerHelpers
  describe "routes" do
    it "routes to #index" do
      expect(get: "/plates").to route_to("plates#index")
    end

    it "routes to #show" do
      expect(get: "/plates/1").to route_to("plates#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/plates/1/edit").to route_to("plates#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/plates").to route_to("plates#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/plates/1").to route_to("plates#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/plates/1").to route_to("plates#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/plates/1").to route_to("plates#destroy", id: "1")
    end
  end


  describe('not signed in redirects all requests to sign in') do
    it "routes to #index" do
      get :index
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "routes to #show" do
      # expect(get: "/plates/1").to route_to("plates#show", id: "1")
      get :show, params: {id: 1}
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "routes to #edit" do
      get :edit, params: {id: 1}
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "routes to #update via PUT" do
      put :update, params: {id: 1}
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "routes to #update via PATCH" do
      patch :update, params: {id: 1}
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "routes to #destroy" do
      delete :destroy, params: {id: 1}
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe('signed in as a patient should not allow any actions for plates') do
    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = create(:user, role: User.roles[:patient]) # in factories.rb you should create a factory for user
      sign_in @user
      @plate = create(:plate, wells: build_list(:well, 96))
    end

    it "routes to #index" do
      get :index
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end

    it "routes to #show" do
      # expect(get: "/plates/1").to route_to("plates#show", id: "1")
      get :show, params: {id: @plate.id}
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end

    it "routes to #edit" do
      get :edit, params: {id: @plate.id}
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end

    it "routes to #update via PUT" do
      put :update, params: {id: @plate.id}
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end

    it "routes to #update via PATCH" do
      patch :update, params: {id: @plate.id}
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end

    it "routes to #destroy" do
      delete :destroy, params: {id: @plate.id}
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end
  end

  describe('signed in as a staff member should be able to edit / update plates') do
    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = create(:user, role: User.roles[:staff]) # in factories.rb you should create a factory for user
      sign_in @user
      @plate = create(:plate, wells: build_list(:well, 96))
    end

    it "routes to #index" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "routes to #show" do
      # expect(get: "/plates/1").to route_to("plates#show", id: "1")
      get :show, params: {id: @plate.id}
      expect(response).to have_http_status(:success)
    end

    it "routes to #edit" do
      get :edit, params: {id: @plate.id}
      expect(response).to have_http_status(:success)
    end

    it "routes to #update via PUT" do
      put :update, params: { id: @plate.id, plate: {id: @plate.id} }
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(plate_path(@plate))
    end

    it "routes to #update via PATCH" do
      patch :update, params: {id: @plate.id, plate: {id: @plate.id}}
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(plate_path(@plate))
    end

    it "routes to #destroy" do
      delete :destroy, params: {id: @plate.id}
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(plates_path)
    end
  end

end
