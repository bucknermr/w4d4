class AddSessionTokensTable < ActiveRecord::Migration[5.1]
  def change
    create_table :session_tokens do |t|
      t.integer :user_id, null: false
      t.string :token, null: false
    end

    add_index :session_tokens, :user_id
  end
end
