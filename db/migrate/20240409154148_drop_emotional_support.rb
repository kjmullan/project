class DropEmotionalSupport < ActiveRecord::Migration[7.0]
  def change
    drop_table :emotional_support
  end
end
