class CreateComments < ActiveRecord::Migration
    def change
        create_table :comments do |t|
            t.string :content
            t.integer :user_id
            t.integer :topic_id

            t.timestamps
        end
        add_index :comments, [:topic_id, :user_id]
    end
end
