class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.belongs_to :user,   null: true
      t.belongs_to :status, null: true
      t.string :user_name,  null: false
      t.string :email,      null: false
      t.string :reference,  null: false
      t.string :subject,    null: false

      t.timestamps
    end

    add_index :tickets, :reference, unique: true
  end
end
