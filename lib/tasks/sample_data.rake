namespace :db do
    desc "Fill database with sample data"
    task populate: :environment do
        User.create!(name:      "Test user",
                     email:     "test@sabaton.com",
                     password:  "123456",
                     password_confirmation: "123456")
        40.times do |n|
            name        = Faker::Name.name
            email       = "test#{n + 1}@sabaton.com"
            password    = "123456"
            User.create!(name:      name,
                         email:     email,
                         password:  password,
                         password_confirmation: password) 
        end   
        
        users = User.all(limit: 6)
        50.times do
            users.each do |user|
                content = Faker::Lorem.sentence(20)
                user.aspect_topics.create!(content: content)
            end
        end          
    end
end