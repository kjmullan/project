require 'rails_helper'

RSpec.describe FutureMessagesBubble, type: :model do
  let(:future_message) { create(:future_message) }
  let(:bubble) { create(:bubble) }
  let(:future_messages_bubble) { create(:future_messages_bubble, future_message: future_message, bubble: bubble) }

  context "associations" do
    it { should belong_to(:future_message).class_name('FutureMessage').with_foreign_key('future_message_id') }
    it { should belong_to(:bubble).class_name('Bubble').with_foreign_key('bubble_id') }
  end

  context "validations" do
    it "is valid with valid attributes" do
      expect(future_messages_bubble).to be_valid
    end

    it "is not valid without a future_message" do
      future_messages_bubble.future_message = nil
      expect(future_messages_bubble).not_to be_valid
    end

    it "is not valid without a bubble" do
      future_messages_bubble.bubble = nil
      expect(future_messages_bubble).not_to be_valid
    end

    it "ensures uniqueness of future_message scoped to bubble" do
      duplicate = build(:future_messages_bubble, future_message: future_message, bubble: bubble)
      expect(duplicate).not_to be_valid
    end
  end
end
