class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :note, index: true
      t.string :content
      t.boolean :completed, default: false
      t.integer :position, default: 0

      t.timestamps
    end
  end
end
