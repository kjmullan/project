# spec/factories/invites.rb
FactoryBot.define do
    factory :invite do
      email { "test@example.com" }
      role  { "supporter" }
      token { SecureRandom.hex(10) }
      message { "Welcome to our platform!" }
    end
  end
  