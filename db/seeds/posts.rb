Post.destroy_all

post =
  Post.create!(
    title: "Test Title ",
    body: "Test Body",
    author: "Test Author"
  )
  puts "Created post: #{post.title}"

3.times do |n|
  post =
    Post.create!(
      title: Faker::Books::Lovecraft.tome,
      body: Faker::Books::Lovecraft.fhtagn(number: 3),
      author: Faker::Name.name
    )
  puts "Created post: #{post.title}"
end