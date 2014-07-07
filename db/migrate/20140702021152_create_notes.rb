class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :position, default: 0
      t.string :kind, default: "Note"
      t.string :title
      t.text :content
      t.string :color
      t.boolean :archived, default: false

      t.timestamps
    end
    
    add_index :notes, :title
    add_index :notes, [:title, :content]
  end
end
