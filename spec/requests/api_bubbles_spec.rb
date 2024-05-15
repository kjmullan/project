# spec/controllers/api/v1/bubbles_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::BubblesController, type: :controller do
  let(:young_person_user) { create(:user, :young_person) }
  let(:young_person) { young_person_user.young_person }
  let(:bubble) { create(:bubble, holder: young_person) }
  let(:member) { create(:user) }
  let(:admin) { create(:user, :admin) }

  before do
    sign_in young_person_user
  end

  describe "GET #index" do
    context "when user is a young person" do
      before do
        get :index
      end

      it "returns the bubbles associated with the young person" do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["bubbles"]).to eq(young_person.bubbles.map { |b| { "id" => b.id, "name" => b.name, "total_members" => b.members.count } })
      end
    end

    context "when user is not authenticated" do
      before do
        sign_out young_person_user
        get :index
      end

      it "returns an unauthorized status" do
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)["message"]).to eq("User is not a young person")
      end
    end
  end

  describe "GET #show" do
    context "when user is the holder of the bubble" do
      before do
        get :show, params: { id: bubble.id }
      end

      it "returns the bubble details" do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({
          "id" => bubble.id,
          "name" => bubble.name,
          "holder_id" => bubble.holder_id,
          "members" => bubble.members.map { |m| { "id" => m.id, "name" => m.name, "email" => m.email } }
        })
      end
    end

    context "when user is not the holder of the bubble" do
      let(:other_user) { create(:user, :young_person) }

      before do
        sign_in other_user
        get :show, params: { id: bubble.id }
      end

      it "returns an empty array" do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq([])
      end
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_attributes) { { name: "New Bubble", holder_id: young_person.id } }

      it "creates a new bubble" do
        expect {
          post :create, params: { bubble: valid_attributes }
        }.to change(Bubble, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["name"]).to eq("New Bubble")
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { { name: nil, holder_id: young_person.id } }

      it "does not create a new bubble" do
        post :create, params: { bubble: invalid_attributes }

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to have_key("name")
      end
    end
  end

  describe "PATCH/PUT #update" do
    context "with valid parameters" do
      let(:new_attributes) { { name: "Updated Bubble" } }

      before do
        put :update, params: { id: bubble.id, bubble: new_attributes }
        bubble.reload
      end

      it "updates the bubble" do
        expect(bubble.name).to eq("Updated Bubble")
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { { name: nil } }

      before do
        put :update, params: { id: bubble.id, bubble: invalid_attributes }
      end

      it "returns a bad request status" do
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to have_key("name")
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the bubble" do
      bubble
      expect {
        delete :destroy, params: { id: bubble.id }
      }.to change(Bubble, :count).by(-1)

      expect(response).to have_http_status(:accepted)
    end
  end

  describe "POST #assign" do
    before do
      @bubble_assign_params = { bubble_id: bubble.id, member: { id: member.id } }
    end

    it "assigns a member to the bubble" do
      expect {
        post :assign, params: @bubble_assign_params
      }.to change { bubble.members.count }.by(1)

      expect(response).to have_http_status(:accepted)
      expect(JSON.parse(response.body)["members"].map { |m| m["id"] }).to include(member.id)
    end
  end

  describe "POST #unassign" do
    before do
      bubble.members << member
      @bubble_unassign_params = { bubble_id: bubble.id, member: { id: member.id } }
    end

    it "unassigns a member from the bubble" do
      expect {
        post :unassign, params: @bubble_unassign_params
      }.to change { bubble.members.count }.by(-1)

      expect(response).to have_http_status(:accepted)
      expect(JSON.parse(response.body)["members"].map { |m| m["id"] }).not_to include(member.id)
    end
  end
end
