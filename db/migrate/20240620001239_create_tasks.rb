class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.integer :state, default: 0, null: false
      t.datetime :deadline
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :tasks, :state
  end
end
