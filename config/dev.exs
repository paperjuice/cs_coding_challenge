import Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we can use it
# to bundle .js and .css sources.
config :crafting_software, CraftingSoftwareWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [
    ip: {0, 0, 0, 0},
    port: 9963
  ],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "5NOnZowA3aDBqU2YayjyCpOGKeCE43bpVJJDQa9/NY9nhhsfCHkfx/oYS0ndIurd",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:crafting_software, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:crafting_software, ~w(--watch)]}
  ]

# Watch static and templates for browser reloading.
config :crafting_software, CraftingSoftwareWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/crafting_software_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  # Include HEEx debug annotations as HTML comments in rendered markup
  debug_heex_annotations: true,
  # Enable helpful, but potentially expensive runtime checks
  enable_expensive_runtime_checks: true
