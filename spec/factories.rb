FactoryGirl.define do
    factory :user do
        # name        "Aaron Podell"
        # email       "aaron@email.com"
        # password    "foobar"
        # password_confirmation   "foobar"

        sequence(:name) { |n| "Person #{n}" }
        sequence(:email) { |n| "person_#{n}@example.com"}
        password "foobar"
        password_confirmation "foobar"
    end
end