class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :name
      t.string :email
      t.string :password  
      t.string :Pronouns
      t.string :status
      t.string :role

      t.timestamps
    end
  end
end
