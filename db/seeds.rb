30.times do |n|
  title = "New number #{n}"
  content = "Random content #{n}"
  New.create!(title: title, content: content)
end
