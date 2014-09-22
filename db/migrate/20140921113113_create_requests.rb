class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.belongs_to :ticket, null: false
      t.text :body,         null: false

      t.timestamps
    end
  end
end
