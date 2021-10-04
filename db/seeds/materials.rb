Material.destroy_all

material =
  Material.create!(
    title: "Test Material ",
    description: "Test Description"
  )
  puts "Created material: #{material.title}"

3.times do |n|
  material =
    Material.create!(
      title: Faker::Books::Lovecraft.tome,
      description: Faker::Books::Lovecraft.fhtagn(number: 3)
    )
  puts "Created material: #{material.title}"
end