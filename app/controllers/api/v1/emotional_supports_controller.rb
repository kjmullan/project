# app/controllers/api/v1/emotional_supports_controller.rb
# Controller for managing emotional support requests via API endpoints.
# This controller handles actions related to emotional support requests such as listing, creating, completing, and deleting.

class Api::V1::EmotionalSupportsController < ActionController::API
  before_action :authenticate_user!

  # GET /api/v1/emotional_supports
  # Retrieves all emotional support requests.
  def index
    @emotional_supports = EmotionalSupport.all
    render json: @emotional_supports
  end

  # POST /api/v1/emotional_supports
  # Creates a new emotional support request.
  def create
    @emotional_support = current_user.emotional_supports.build(emotional_support_params)
    if @emotional_support.save
      render json: @emotional_support, status: :created
    else
      render json: { errors: @emotional_support.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/emotional_supports/:id
  # Deletes a specific emotional support request.
  def destroy
    @emotional_support = current_user.emotional_supports.find(params[:id])
    @emotional_support.destroy
    render json: { message: 'Emotional support request was successfully deleted.' }
  end

  # PATCH/PUT /api/v1/emotional_supports/:id/complete
  # Marks a specific emotional support request as completed.
  def complete
    @emotional_support = current_user.emotional_supports.find(params[:id])
    if @emotional_support.update(status: true)
      render json: { message: 'Emotional support request was successfully completed.' }
    else
      render json: { error: 'Emotional support request could not be completed.' }, status: :unprocessable_entity
    end
  end

  private

  # Whitelists permissible parameters for creating emotional support requests.
  def emotional_support_params
    params.require(:emotional_support).permit(:content)
  end
end
