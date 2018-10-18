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

users = User.order(:created_at).take(5)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end
