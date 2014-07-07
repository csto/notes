class CreateUserNotes < ActiveRecord::Migration
  def change
    create_table :user_notes do |t|
      t.references :user, index: true
      t.references :note, index: true

      t.timestamps
    end
  end
end
