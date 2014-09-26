class CreateShareTokens < ActiveRecord::Migration
  def change
    create_table :share_tokens do |t|
      t.references :note, index: true
      t.string :token

      t.timestamps
    end
  end
end
