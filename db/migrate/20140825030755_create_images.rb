class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.references :note, index: true

      t.timestamps
    end
  end
end
