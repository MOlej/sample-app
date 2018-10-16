User.create!(name: "Administrator",
             email: "admin@example.com",
             password: "Passw0rd",
             password_confirmation: "Passw0rd",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name = Faker::Name.name
  email = "user-#{n+1}@example.com"
  password = "Passw0rd"

  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end
