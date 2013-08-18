FactoryGirl.define do
    factory :user do
        name        "Le Hong Trieu"
        email       "lhtrieu87@gmail.com"
        password    "123456"
        password_confirmation "123456"
    end

    factory :aspect_topic do
        content "Lorem ipsum"
        user
    end
end