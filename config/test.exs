import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :crafting_software, CraftingSoftwareWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "+ANe52rMT/mVPue2BLrreqgffcUhKbB0Yv+JqHRIos+k/krPn9B4uEE2RH8JI4Km",
  server: false

# In test we don't send emails
config :crafting_software, CraftingSoftware.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
