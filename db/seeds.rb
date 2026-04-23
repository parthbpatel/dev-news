# frozen_string_literal: true

unless Rails.env.development? || Rails.env.test? || ENV['ALLOW_DEMO_SEEDS'] == '1'
  abort 'Demo seeds are limited to development/test. Set ALLOW_DEMO_SEEDS=1 to force seeding in another environment.'
end

SEED_PASSWORD = 'password123'

USERNAMES = %w[
  alice
  bob
  charlie
  dana
  evelyn
  faris
  gina
  harry
  isabel
  jordan
  kevin
  lina
  mason
  nina
].freeze

LINK_BLUEPRINTS = [
  {
    submitted_by: 'alice',
    title: 'Rails caching patterns for multi-tenant SaaS applications',
    url: 'https://guides.rubyonrails.org/caching_with_rails.html',
    description: 'A practical refresher on low-level caching, Russian doll caching, and the places where cache invalidation usually bites growing Rails teams.',
    topic: 'caching',
    hours_ago: 3,
    upvotes: 8,
    downvotes: 1,
    comment_count: 9
  },
  {
    submitted_by: 'bob',
    title: 'How teams are adopting Hotwire without rewriting their UI stack',
    url: 'https://hotwired.dev/',
    description: 'A collection of rollout notes that focus on incremental migration, developer ergonomics, and the tradeoffs between Stimulus, Turbo Frames, and Turbo Streams.',
    topic: 'hotwire adoption',
    hours_ago: 6,
    upvotes: 7,
    downvotes: 1,
    comment_count: 8
  },
  {
    submitted_by: 'charlie',
    title: 'Ask Dev News: what is your production incident review template?',
    url: nil,
    description: 'A text post collecting postmortem formats, facilitation tactics, and the prompts teams actually reuse after the excitement fades.',
    topic: 'incident reviews',
    hours_ago: 8,
    upvotes: 6,
    downvotes: 0,
    comment_count: 10
  },
  {
    submitted_by: 'dana',
    title: 'A field guide to background jobs, retries, and queue isolation in Rails',
    url: 'https://edgeguides.rubyonrails.org/active_job_basics.html',
    description: 'Less theory, more operational detail: retries, idempotency, poison messages, and the moments when a single queue becomes everyone''s problem.',
    topic: 'background jobs',
    hours_ago: 12,
    upvotes: 8,
    downvotes: 2,
    comment_count: 7
  },
  {
    submitted_by: 'evelyn',
    title: 'Designing internal APIs that survive the third client team',
    url: 'https://martinfowler.com/articles/richardsonMaturityModel.html',
    description: 'An opinionated write-up on versioning, change management, and keeping internal API contracts boring enough to scale.',
    topic: 'internal APIs',
    hours_ago: 15,
    upvotes: 5,
    downvotes: 1,
    comment_count: 5
  },
  {
    submitted_by: 'faris',
    title: 'What senior engineers look for when reviewing database migrations',
    url: nil,
    description: 'A text thread on backfills, locking behavior, rollout sequencing, and how to spot migrations that will wake up on-call later.',
    topic: 'database migrations',
    hours_ago: 18,
    upvotes: 6,
    downvotes: 0,
    comment_count: 8
  },
  {
    submitted_by: 'gina',
    title: 'The best debugging stories all start with a wrong assumption',
    url: 'https://sre.google/sre-book/postmortem-culture/',
    description: 'A reflective piece on debugging narratives, hidden assumptions, and the habits that keep teams curious under pressure.',
    topic: 'debugging',
    hours_ago: 20,
    upvotes: 7,
    downvotes: 1,
    comment_count: 6
  },
  {
    submitted_by: 'harry',
    title: 'Making design system tokens usable across product, docs, and email',
    url: 'https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties',
    description: 'A practical deep dive into naming, ownership, and why token governance tends to matter more than token generation.',
    topic: 'design tokens',
    hours_ago: 24,
    upvotes: 5,
    downvotes: 1,
    comment_count: 4
  },
  {
    submitted_by: 'isabel',
    title: 'The hidden maintenance cost of clever CI pipelines',
    url: 'https://docs.github.com/actions',
    description: 'Examples of CI setups that looked elegant on day one and became impossible to debug after six months of feature work.',
    topic: 'continuous integration',
    hours_ago: 27,
    upvotes: 5,
    downvotes: 2,
    comment_count: 5
  },
  {
    submitted_by: 'jordan',
    title: 'Why product analytics breaks when event ownership is fuzzy',
    url: 'https://amplitude.com/blog/',
    description: 'A sharp reminder that instrumentation plans, naming discipline, and event audits are organizational work before they are tracking work.',
    topic: 'product analytics',
    hours_ago: 31,
    upvotes: 6,
    downvotes: 1,
    comment_count: 6
  },
  {
    submitted_by: 'kevin',
    title: 'Shipping dark launches without leaving dead flags everywhere',
    url: 'https://martinfowler.com/articles/feature-toggles.html',
    description: 'Notes on release coordination, flag TTLs, and the cleanup rituals that separate safe experimentation from permanent complexity.',
    topic: 'feature flags',
    hours_ago: 36,
    upvotes: 7,
    downvotes: 0,
    comment_count: 7
  },
  {
    submitted_by: 'lina',
    title: 'Ask Dev News: what do you automate first on a new platform team?',
    url: nil,
    description: 'A text-only discussion on paved roads, service templates, and the order of operations that actually helps product teams move faster.',
    topic: 'platform engineering',
    hours_ago: 42,
    upvotes: 4,
    downvotes: 0,
    comment_count: 9
  },
  {
    submitted_by: 'mason',
    title: 'Secrets management checklists that engineers still forget in 2026',
    url: 'https://cheatsheetseries.owasp.org/',
    description: 'A security-focused checklist covering developer laptops, CI logs, environment parity, and the little paper cuts that lead to leaks.',
    topic: 'secrets management',
    hours_ago: 48,
    upvotes: 6,
    downvotes: 1,
    comment_count: 5
  },
  {
    submitted_by: 'nina',
    title: 'What fast teams do before they parallelize a roadmap',
    url: 'https://basecamp.com/shapeup',
    description: 'A strategy post about sequencing, reducing ambiguity, and why clear boundaries usually matter more than extra meetings.',
    topic: 'roadmap planning',
    hours_ago: 54,
    upvotes: 5,
    downvotes: 1,
    comment_count: 6
  },
  {
    submitted_by: 'alice',
    title: 'Documenting production runbooks so they still help at 3am',
    url: 'https://response.pagerduty.com/',
    description: 'How strong runbooks balance speed, context, and judgement instead of pretending incidents are simple checklists.',
    topic: 'runbooks',
    hours_ago: 60,
    upvotes: 7,
    downvotes: 1,
    comment_count: 8
  },
  {
    submitted_by: 'bob',
    title: 'The performance wins that came from deleting background work',
    url: 'https://12factor.net/processes',
    description: 'Case studies where removing duplicate indexing, fan-out notifications, and stale sync jobs improved latency more than optimization did.',
    topic: 'performance cleanup',
    hours_ago: 72,
    upvotes: 6,
    downvotes: 1,
    comment_count: 5
  },
  {
    submitted_by: 'charlie',
    title: 'A practical checklist for onboarding engineers into a monolith',
    url: 'https://docs.github.com/en/get-started/quickstart',
    description: 'What actually helps on week one: architecture maps, sample tickets, release context, and names of the people who own the sharp edges.',
    topic: 'engineering onboarding',
    hours_ago: 84,
    upvotes: 8,
    downvotes: 1,
    comment_count: 7
  },
  {
    submitted_by: 'dana',
    title: 'How we review observability debt before it becomes outage debt',
    url: 'https://opentelemetry.io/docs/',
    description: 'A useful framework for spotting missing spans, noisy alerts, and dashboards that drifted away from how systems really behave.',
    topic: 'observability',
    hours_ago: 96,
    upvotes: 5,
    downvotes: 1,
    comment_count: 6
  },
  {
    submitted_by: 'evelyn',
    title: 'Writing release notes that engineers and customers both read',
    url: nil,
    description: 'A discussion about audience, detail level, and the specific types of change notes that reduce support load.',
    topic: 'release notes',
    hours_ago: 108,
    upvotes: 4,
    downvotes: 0,
    comment_count: 5
  },
  {
    submitted_by: 'faris',
    title: 'Container image size audits that led to faster deploys',
    url: 'https://docs.docker.com/build/',
    description: 'An operations-focused walkthrough of trimming build contexts, tightening layers, and keeping deploys fast as services accumulate tools.',
    topic: 'container images',
    hours_ago: 120,
    upvotes: 5,
    downvotes: 1,
    comment_count: 4
  },
  {
    submitted_by: 'gina',
    title: 'The code review comments that actually improve systems thinking',
    url: 'https://google.github.io/eng-practices/review/',
    description: 'A healthy reminder that strong reviews challenge assumptions, surface edge cases, and teach architectural judgement without grandstanding.',
    topic: 'code review',
    hours_ago: 132,
    upvotes: 6,
    downvotes: 0,
    comment_count: 5
  },
  {
    submitted_by: 'harry',
    title: 'Migrating cron jobs into a queue without losing visibility',
    url: 'https://sidekiq.org/',
    description: 'A pragmatic migration story about ownership, retry behavior, monitoring, and keeping scheduled work visible after the move.',
    topic: 'scheduled work',
    hours_ago: 144,
    upvotes: 5,
    downvotes: 1,
    comment_count: 6
  },
  {
    submitted_by: 'isabel',
    title: 'What teams regret after choosing seven metrics for one dashboard',
    url: nil,
    description: 'A text post about dashboard sprawl, stale KPIs, and why teams need decision-driven metrics instead of decorative analytics.',
    topic: 'dashboards',
    hours_ago: 156,
    upvotes: 4,
    downvotes: 1,
    comment_count: 4
  },
  {
    submitted_by: 'jordan',
    title: 'The best API changelogs read like migration guides',
    url: 'https://docs.stripe.com/changelog',
    description: 'A product engineering take on changelog clarity, rollout hints, and the trust teams build when version changes are easy to follow.',
    topic: 'API changelogs',
    hours_ago: 168,
    upvotes: 6,
    downvotes: 0,
    comment_count: 5
  }
].freeze

COMMENT_OPENERS = [
  'We ran into something similar recently.',
  'This is the kind of write-up I wish more teams shared.',
  'The operational detail here is the interesting part.',
  'I like that this focuses on tradeoffs instead of pretending there is one correct answer.',
  'This lines up with what we learned after a messy rollout.',
  'The strongest section is the part that deals with team habits, not just tooling.'
].freeze

COMMENT_OBSERVATIONS = [
  'Treating %<topic>s as an ownership problem usually makes the technical decisions much easier to revisit later.',
  'The part about sequencing felt especially relevant because most of our issues showed up at the handoff points.',
  'What stood out to me was how much calmer the system becomes once the defaults are explicit.',
  'This mirrors our experience: the implementation was straightforward, but the workflow boundaries needed real thought.',
  'It is refreshing to see %<topic>s described as a product and maintenance concern instead of just a code concern.',
  'The examples here would make a great onboarding artifact for engineers who are inheriting this area.'
].freeze

COMMENT_CLOSES = [
  'I would love to see a follow-up with what changed six months later.',
  'Curious how other teams document the edge cases around this.',
  'The comments on this one should be useful for anyone planning a similar migration.',
  'This is getting saved to our internal reading list.',
  'We could probably borrow this framing for our next retro.',
  'It would be great to compare this with how smaller teams approach the same problem.'
].freeze

LINK_BLUEPRINTS.each_with_index do |blueprint, index|
  blueprint[:seed_offset] = index
end

def create_comment_body(topic, comment_index, seed_offset)
  opener = COMMENT_OPENERS[(comment_index + seed_offset) % COMMENT_OPENERS.length]
  observation = format(COMMENT_OBSERVATIONS[(comment_index * 2 + seed_offset) % COMMENT_OBSERVATIONS.length], topic: topic)
  closer = COMMENT_CLOSES[(comment_index * 3 + seed_offset) % COMMENT_CLOSES.length]

  "#{opener} #{observation} #{closer}"
end

def vote_timestamp(link_created_at, offset)
  [link_created_at + ((offset + 1) * 11).minutes, Time.current - 3.minutes].min
end

def comment_timestamp(link_created_at, offset)
  [link_created_at + ((offset + 1) * 47).minutes, Time.current - 2.minutes].min
end

ActiveRecord::Base.transaction do
  puts 'Resetting demo content...'
  Vote.delete_all
  Comment.delete_all
  Link.delete_all
  User.delete_all

  users = USERNAMES.each_with_object({}) do |username, memo|
    memo[username] = User.create!(username: username, password: SEED_PASSWORD)
  end

  puts "Created #{users.size} users"

  links = LINK_BLUEPRINTS.map do |blueprint|
    owner = users.fetch(blueprint[:submitted_by])
    created_at = Time.current - blueprint[:hours_ago].hours

    owner.links.create!(
      title: blueprint[:title],
      url: blueprint[:url],
      description: blueprint[:description],
      created_at: created_at,
      updated_at: created_at + 10.minutes
    )
  end

  puts "Created #{links.size} links"

  links.each_with_index do |link, index|
    blueprint = LINK_BLUEPRINTS[index]
    available_commenters = users.values.reject { |user| user == link.user }.rotate(index)

    blueprint[:comment_count].times do |comment_index|
      commenter = available_commenters[comment_index % available_commenters.length]
      created_at = comment_timestamp(link.created_at, comment_index)

      Comment.create!(
        user: commenter,
        link: link,
        body: create_comment_body(blueprint[:topic], comment_index, blueprint[:seed_offset]),
        created_at: created_at,
        updated_at: created_at
      )
    end

    available_voters = users.values.reject { |user| user == link.user }.rotate(index)
    up_voters = available_voters.first(blueprint[:upvotes])
    down_voters = available_voters.drop(blueprint[:upvotes]).first(blueprint[:downvotes])

    up_voters.each_with_index do |voter, vote_index|
      created_at = vote_timestamp(link.created_at, vote_index)
      Vote.create!(user: voter, link: link, value: Vote::UP, created_at: created_at, updated_at: created_at)
    end

    down_voters.each_with_index do |voter, vote_index|
      created_at = vote_timestamp(link.created_at, blueprint[:upvotes] + vote_index)
      Vote.create!(user: voter, link: link, value: Vote::DOWN, created_at: created_at, updated_at: created_at)
    end

    link.refresh_ranking!
  end

  puts "Created #{Comment.count} comments"
  puts "Created #{Vote.count} votes"
end

puts
puts 'Demo data ready.'
puts "Sample login: alice / #{SEED_PASSWORD}"
puts "Users: #{User.count}, links: #{Link.count}, comments: #{Comment.count}, votes: #{Vote.count}"
puts 'You now have enough records to exercise multi-page link feeds, sitewide comments, and deep comment threads.'
