# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

# Create users
user1 = User.create!(username: 'alice', password: 'password123')
user2 = User.create!(username: 'bob', password: 'password123')
user3 = User.create!(username: 'charlie', password: 'password123')

# Create links
link1 = Link.create!(title: 'Ruby on Rails Guide', url: 'https://guides.rubyonrails.org/', description: 'Official Rails guides', user: user1)
link2 = Link.create!(title: 'GitHub', url: 'https://github.com/', description: 'Code hosting platform', user: user2)
link3 = Link.create!(title: 'Stack Overflow', url: 'https://stackoverflow.com/', description: 'Q&A for developers', user: user3)
link4 = Link.create!(title: 'MDN Web Docs', url: 'https://developer.mozilla.org/', description: 'Web development documentation', user: user1)
link5 = Link.create!(title: 'Dev.to', url: 'https://dev.to/', description: 'Community for developers', user: user2)

# Create comments
Comment.create!(body: 'Great resource for learning Rails!', user: user2, link: link1)
Comment.create!(body: 'I use this every day.', user: user3, link: link2)
Comment.create!(body: 'Very helpful for beginners.', user: user1, link: link3)
Comment.create!(body: 'Comprehensive documentation.', user: user3, link: link4)
Comment.create!(body: 'Love the community posts.', user: user1, link: link5)
Comment.create!(body: 'Thanks for sharing!', user: user2, link: link1)

# Create votes
Vote.create!(user: user2, link: link1, upvote: 1, downvote: 0)
Vote.create!(user: user3, link: link1, upvote: 1, downvote: 0)
Vote.create!(user: user1, link: link2, upvote: 1, downvote: 0)
Vote.create!(user: user3, link: link2, upvote: 0, downvote: 1)
Vote.create!(user: user1, link: link3, upvote: 1, downvote: 0)
Vote.create!(user: user2, link: link4, upvote: 1, downvote: 0)
Vote.create!(user: user3, link: link5, upvote: 1, downvote: 0)
