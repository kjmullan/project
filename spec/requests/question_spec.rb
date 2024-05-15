require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  # Create a QuesCategory before each test
  let(:ques_category) { create(:ques_category)}

  # Define valid and invalid attributes for testing
  let(:valid_attributes) {
    { content: 'What is RSpec?', ques_category_id: ques_category.id, sensitivity: 'false', active: 'true'}
  }

  let(:invalid_attributes) {
    { content: '', ques_category_id: nil }
  }

  # Set up a user and sign them in before each test
  before do
    user = create(:user)
    sign_in user
  end

  # Test the index action
  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  # Test the show action
  describe "GET #show" do
    it "returns a success response" do
      question = create(:question, valid_attributes)
      get :show, params: { id: question.id }
      expect(response).to be_successful
    end
  end

  # Test the create action
  describe "POST #create" do
    context "with valid params" do
      it "creates a new Question" do
        expect {
          post :create, params: { question: valid_attributes }
        }.to change(Question, :count).by(1)
      end

      it "redirects to the questions list" do
        post :create, params: { question: valid_attributes }
        expect(response).to redirect_to(questions_path)
      end
    end

    context "with invalid params" do
      it "does not create a new Question and redirects to the new question form" do
        post :create, params: { question: invalid_attributes }
        expect(response).to redirect_to(new_question_path)
        expect(Question.count).to eq(0)
        expect(flash[:alert]).to be_present
      end
    end
  end

  # Test the update action
  describe "PUT #update" do
    context "with valid params" do
      it "updates the requested question" do
        question = create(:question, valid_attributes)
        put :update, params: { id: question.id, question: valid_attributes.merge(content: 'Updated content') }
        question.reload
        expect(question.content).to eq('Updated content')
      end

      it "redirects to the questions list" do
        question = create(:question, valid_attributes)
        put :update, params: { id: question.id, question: valid_attributes.merge(content: 'Updated content') }
        expect(response).to redirect_to(questions_path)
      end
    end

    context "with invalid params" do
      it "renders the edit template" do
        question = create(:question, valid_attributes)
        put :update, params: { id: question.id, question: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)  
      end
    end
  end

  # Test the destroy action
  describe "DELETE #destroy" do
    it "soft deletes the requested question" do
      question = create(:question, valid_attributes.merge(active: false))
      delete :destroy, params: { id: question.id }
      question.reload
      expect(question.active).to be_falsey
    end

    it "redirects to the questions list" do
      question = create(:question, valid_attributes.merge(active: false))
      delete :destroy, params: { id: question.id }
      expect(response).to redirect_to(questions_url(host: 'test.host'))
    end
  end
end
