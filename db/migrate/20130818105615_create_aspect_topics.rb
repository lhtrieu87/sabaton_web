class CreateAspectTopics < ActiveRecord::Migration
    def change
        create_table :aspect_topics do |t|
            t.string :content
            t.integer :user_id

            t.timestamps
        end
        add_index :aspect_topics, [:user_id, :created_at]
    end
end
