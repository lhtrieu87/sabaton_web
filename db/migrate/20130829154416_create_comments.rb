class CreateComments < ActiveRecord::Migration
    def change
        create_table :comments do |t|
            t.string :content
            t.integer :user_id
            t.integer :aspect_topic_id

            t.timestamps
        end
        add_index :comments, [:user_id, :aspect_topic_id]
    end
end
