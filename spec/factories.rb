FactoryGirl.define do
    factory :user do
        name        "Aaron Podell"
        email       "aaron@email.com"
        password    "foobar"
        password_confirmation   "foobar"
    end
end