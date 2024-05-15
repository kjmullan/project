# app/controllers/bubbles_controller.rb
# Controller responsible for managing Bubble resources within the application.
# This includes CRUD operations and additional functions for assigning and unassigning members to bubbles.

class BubblesController < ApplicationController
    # Ensures a user is authenticated for all actions within this controller.
    before_action :authenticate_user!
    
    # Sets a bubble for actions that require it based on the bubble's ID.
    before_action :set_bubble, only: %i[show update destroy]
    
    # Sets a bubble and member for the assign and unassign actions.
    before_action :set_bubble_assign, only: %i[assign unassign]


    # GET /api/v1/bubbles
    # Lists all bubbles associated with the currently logged-in young person.
    def index
        case current_user.role
        when "loved_one"
          # Retrieve answers for 'loved_one' role where the associated young person has passed away.
          manage_loved_one_access
        when "supporter"
          # Retrieve answers for a specific young person for 'supporter' role.
          manage_supporter_access
        when "young_person"
          # Admins can view all answers.
          @bubbles = current_user.young_person.bubbles
        else
          # Redirect unauthorized users.
          redirect_to root_path, alert: "You are not authorized to view this page."
        end
    end

    # GET /api/v1/bubbles/:id
    # Displays a single bubble.
    def show
    end

    # GET /api/v1/bubbles/new
    # Initializes a new bubble instance for creation.
    def new
        @bubble = Bubble.new
    end

    # POST /api/v1/bubbles
    # Creates a new bubble with the provided parameters from the form.
    def create
        @bubble = Bubble.new(bubble_params)
        @bubble.holder_id = YoungPerson.find_by(user_id: current_user.id).id
    
        if @bubble.save
          redirect_to bubbles_path, notice: 'Bubble was successfully created.'
        else
          render :new
        end
      end

    # GET /api/v1/bubbles/:id/edit
    # Prepares an existing bubble for editing.
    def edit
        @bubble = Bubble.find(params[:id])
    end

    def update
        if @bubble.update(bubble_params)
            redirect_to @bubble, notice: "Bubble was successfully updated."
        else
            render :edit
        end
    end

    # DELETE /api/v1/bubbles/:id
    # Deletes a bubble and redirects to the bubble listing with a success message.
    def destroy
        @bubble.destroy
        redirect_to bubbles_path, notice: "Bubble was successfully destroyed."
    end

    # GET /api/v1/bubbles/:bubble_id/assign
    # Assigns a member to the specified bubble.
    def assign
        @bubble.members << @member
        redirect_to bubble_path(@bubble), notice: "Member was successfully assigned."
    end

    # GET /api/v1/bubbles/:bubble_id/unassign
    # Unassigns a member from the specified bubble.
    def unassign
        @bubble.members.delete @member
        redirect_to bubble_path(@bubble), notice: "Member was successfully unassigned."
    end

    private
    # Finds the bubble based on the ID provided in params.
    def set_bubble
        @bubble = Bubble.find(params[:id])
      end

    # Finds the bubble and member for assignment actions based on their IDs in params.
    def set_bubble_assign
        @bubble = Bubble.find(params[:bubble_id])
        @member = BubbleInvite.find(params[:member_id])
    end

    # Permits only the safe parameters for creating and updating bubbles.
    def bubble_params
        params.require(:bubble).permit(:name, :content, :holder_id)
    end

    def manage_loved_one_access
        bm = BubbleMember.find_by(user_id: current_user.id)
        bubble_invites = BubbleInvite.where(bubble_member_id: bm&.id)
        @bubbles = bubble_invites.flat_map(&:bubbles)
        
    end

    def manage_supporter_access
        if params[:user_id]
          young_person = YoungPerson.find_by(user_id: params[:user_id])
          if young_person
            @bubbles = young_person.bubbles
          else
            redirect_to supporter_dashboard_path, alert: "No young person found."
          end
        else
          redirect_to supporter_dashboard_path, alert: "No young person selected."
        end
    end


end
