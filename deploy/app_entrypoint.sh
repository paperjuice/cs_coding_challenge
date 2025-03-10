#!/bin/bash

mix setup
mix deps.compile
mix compile
exec iex -S mix phx.server
