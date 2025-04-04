# CraftingSoftware

### Overview
This is a small web app that can receive a list of tasks (graph) over HTTP and return a new ordered list based on each tasks' 'requires'.


## Running the app

### Option 1
#### Prerequisites
The project requires you to have [Docker](https://www.docker.com/), [make](https://en.wikipedia.org/wiki/Make_(software)) and [Git](https://git-scm.com/book/en/v2/Getting-Started-The-Command-Line) installed on your machine.
The project was build using Docker version 27.5.1, build 9f9e405

Port 9963 is being used.

First, clone the git project and cd into it
```
git clone https://github.com/paperjuice/cs_coding_challenge.git cs_coding_challenge && cd cs_coding_challenge
```

In order to start the project all you have to do is run
```
make up
```
This command will start the Elixir app.

If you have an older version of Docker (<25.0.3), use:
```
make up_old
```

### Option 2
#### Prerequisites
For option 2, [Git](https://git-scm.com/book/en/v2/Getting-Started-The-Command-Line), Elixir, Erlang are required. This app was tested with Elixir version 1.14 and Erlang 25.1

First, clone the git project and cd into it
```
git clone https://github.com/paperjuice/cs_coding_challenge.git cs_coding_challenge && cd cs_coding_challenge
```

Get dependencies and start the app
```
mix deps.get && iex -S mix phx.server
```


## How to use

Browse to
```
localhost:9963
```
<img width="1496" alt="image" src="https://github.com/user-attachments/assets/fb2726ff-a6d7-42a1-8e76-1ed131835099" />

__Generate task list__ -> Generate a random list but most of the time will include circular dependencies so you will have to press the button a bunch of times until you get a valid list

__Process__ -> process the json in the textarea above.

__Response__ -> Get back a json response containing ordered tasks based on their "requires"

__Bash Script__ -> The __Response__'s commands represented as a bash script

## Tests
Tests can be ran with
```
mix test
```

The full suite of tests can be found: `test/crafting_software/process_test.exs`

## Project structure

`lib/crafting_software/process.ex` -> logic for processing task list, generating a random list of tasks and casting ordered task list to bash

`lib/crafting_software_web/main_live/index.html.heex` -> Main page templace

`lib/crafting_software_web/main_live/index.ex` -> LiveView module for handling main page logic

## Improvements
* Improve the processing function to not duplicate tasks and remove the need for Enum.uniq/1
* Web tests
* Use @callback for public functions to facilitate mocking and transparency
* CI/CD
* Better specs
* Git hooks to mix format/credo on git add
* Improve logging
* Instead of starting the App in interactive shell, start in executable (mix release)
