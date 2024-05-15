require 'rails_helper'

RSpec.describe Api::V1::AnswerAlertsController, type: :controller do
  let(:user) { create(:user) }
  let(:young_person) { create(:young_person, user: user) }
  let(:answer) { create(:answer, young_person: young_person, user_id: user.id) }
  let(:answer_alert) { create(:answer_alert, answer: answer) }
  
  before do
    sign_in user  
  end

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #index" do
    it "returns a list of answer alerts" do
      get :index
      expect(response).to be_successful
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(json_response['answer_alerts'].size).to eq(1)
    end
  end

  describe "GET #show" do
    it "returns a specific answer alert" do
      get :show, params: { id: answer_alert.id }
      expect(response).to be_successful
      expect(json_response['id']).to eq(answer_alert.id)
    end
  end

  describe "POST #create" do
    let(:valid_attributes) {
      { answer_id: answer.id, commit: 'High' }
    }

    it "creates a new answer alert" do
      expect {
        post :create, params: { answer_alert: valid_attributes }
      }.to change(AnswerAlert, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it "returns errors for invalid parameters" do
      post :create, params: { answer_alert: { answer_id: nil } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH/PUT #update" do
    let(:new_attributes) {
      { commit: 'Medium' }
    }

    it "updates an answer alert" do
      patch :update, params: { id: answer_alert.id, answer_alert: new_attributes }
      answer_alert.reload
      expect(answer_alert.commit).to eq('Medium')
      expect(response).to be_successful
    end
  end

  describe "DELETE #destroy" do
    it "sets answer alert to inactive" do
      delete :destroy, params: { id: answer_alert.id }
      expect(response).to have_http_status(:no_content)
      answer_alert.reload
      expect(answer_alert.active).to be_falsey
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
