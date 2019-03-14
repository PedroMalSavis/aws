require 'open-uri'

puts "Seeding users.."
File.open("aws - users.csv", "r") do |f|
  f.each_with_index do |line, index|
    email, name, photo = line.chomp.split (",")
    puts 'seeding user'
    User.create(email: email, name: name, photo: photo, password: '123123')
  end
end


puts "Seeding products.."
File.open("aws - products.csv", "r") do |f|
  f.each_with_index do |line, index|
    user, name, photo = line.chomp.split (",")
    Product.create(user_id: user, name: name, photo: photo)
  end
end

# puts "Seeding services.."
# File.open("services.csv", "r") do |f|
#   f.each_with_index do |line, index|
#     name, photo = line.chomp.split (",")
#   Service.create(name: name, photo: photo)
#   end
# end

# puts "Seeding posts.."
# File.open("aws - posts.csv", "r") do |f|
#   f.each_with_index do |line, index|
#     seller, pic, content = line.chomp.split (",")
#   Post.create(user_id: seller, photo: pic, content: content)
#   end
# end
