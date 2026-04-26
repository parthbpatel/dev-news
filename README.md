# DevNews

A Hacker News-style link aggregator built with Ruby on Rails. Users can submit links, upvote/downvote, comment, and browse content ranked by a hot score algorithm.

🔗 Live Demo: https://dev-news-igg9.onrender.com/

---

## Features

- Authentication — Register and log in with a username and password (bcrypt)
- Link Submission — Submit links with a title, URL, and description
- Voting — Upvote or downvote links; vote toggling is supported
- Hot Score Ranking — Links are ranked by a time-decayed popularity algorithm (gravity = 1.8)
- Newest Feed — Browse links sorted by submission time
- Comments — Add, edit, and delete comments on any link
- Infinite Scroll — Links and comments load progressively via XHR pagination (Intersection Observer API)
- Sitewide Comments Feed — Browse all recent comments across the platform
- Authorization — Users can only edit or delete their own links and comments

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Ruby on Rails 6.1 |
| Language | Ruby 3.1.6 |
| Database | PostgreSQL |
| Frontend | Bootstrap 4.6, Vanilla JS (Webpack via Webpacker 5) |
| Styling | Sass (dartsass-sprockets) |
| Pagination | Pagy (countless mode) |
| Auth | bcrypt (has_secure_password) |
| Server | Puma |
| Deployment | Render |

---

## Getting Started

### Prerequisites

- Ruby 3.1.6
- PostgreSQL
- Node.js 16.x
- Yarn

### Setup

```bash
# Clone the repository
git clone https://github.com/parthbpatel/dev-news.git
cd dev-news

# Install Ruby dependencies
bundle install

# Install JavaScript dependencies
yarn install

# Setup the database
rails db:create db:migrate

# Seed with demo data (development only)
rails db:seed

# Start the server
rails server
```

Visit `http://localhost:3000`

### Demo credentials (after seeding)

```
username: alice
password: password123
```

---

## Project Structure

```
app/
├── controllers/
│   ├── links_controller.rb       # Feed, CRUD, upvote/downvote
│   ├── comments_controller.rb    # Comments CRUD + sitewide feed
│   ├── sessions_controller.rb    # Login / logout
│   └── users_controller.rb       # Registration
├── models/
│   ├── link.rb                   # Hot score ranking logic
│   ├── comment.rb
│   ├── user.rb                   # Username normalization
│   └── vote.rb
├── services/
│   └── votes/toggle.rb           # Vote toggle service object
├── views/
│   ├── links/                    # Feed, show, form views
│   ├── comments/                 # Comment partials + sitewide index
│   └── shared/                   # Navbar, errors, infinite scroll loader
└── javascript/
    └── infinite_scroll.js        # Intersection Observer infinite scroll
```

---

## Ranking Algorithm

Links are scored using a time-decayed hot score:

```ruby
score = points / (age_in_hours + 2) ** gravity
```

This ensures fresh content with engagement ranks above old content, similar to Hacker News.

---

## Deployment (Render)

### Environment Variables

| Variable | Value | Purpose |
|----------|-------|---------|
| `DATABASE_URL` | (Render PostgreSQL URL) | Database connection |
| `SECRET_KEY_BASE` | (generated secret) | Rails credentials |
| `RAILS_MASTER_KEY` | (your master key) | Encrypted credentials |
| `NODE_OPTIONS` | `--openssl-legacy-provider` | Webpack 4 + Node 20 compatibility |
| `ALLOW_DEMO_SEEDS` | `1` | Allow seed data in production (optional) |
| `RAILS_SERVE_STATIC_FILES` | `true` | Serve assets from `/public` |
| `RAILS_LOG_TO_STDOUT` | `true` | Log output to Render console |

### Build Command

```bash
bundle exec rails assets:precompile && bundle exec rails db:migrate
```

### Start Command

```bash
bundle exec puma -C config/puma.rb
```

---

## Routes

```
GET    /                        # Hot feed (links#index)
GET    /newest                  # Newest feed (links#newest)
GET    /comments                # Sitewide comments feed
GET    /links/:id               # Link thread with comments
POST   /links/:id/upvote        # Upvote a link
POST   /links/:id/downvote      # Downvote a link
resources :links                # CRUD
  resources :comments           # CRUD (nested)
resource  :session              # Login / logout
resources :users, only: [:new, :create]  # Registration
```

---

## License

MIT
