class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.belongs_to :request, null: false
      t.belongs_to :user,    null: false
      t.text :body,          null: false

      t.timestamps
    end
  end
end
