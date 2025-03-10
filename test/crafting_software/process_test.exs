defmodule CraftingSoftware.ProcessTest do
  @moduledoc false

  alias CraftingSoftware.Process

  use CraftingSoftwareWeb.ConnCase, async: true

  describe "task_list/1" do
    test "successfully orders tasks with no requires" do
      data = [
        %{"command" => "touch /tmp/file1", "name" => "task-1"},
        %{"command" => "cat /tmp/file1", "name" => "task-3"},
        %{"command" => "echo 'Hello World!' > /tmp/file1", "name" => "task-4"},
        %{"command" => "rm /tmp/file1", "name" => "task-2"}
      ]

      {:ok, actual_data} = Process.task_list(data)

      expected_data = [
        %{"command" => "rm /tmp/file1", "name" => "task-2"},
        %{"command" => "echo 'Hello World!' > /tmp/file1", "name" => "task-4"},
        %{"command" => "cat /tmp/file1", "name" => "task-3"},
        %{"command" => "touch /tmp/file1", "name" => "task-1"}
      ]

      assert actual_data == expected_data
    end

    test "successfully orders tasks with requires" do
      data = [
        %{"command" => "touch /tmp/file1", "name" => "task-1", "requires" => ["task-2"]},
        %{"command" => "cat /tmp/file1", "name" => "task-3"},
        %{
          "command" => "echo 'Hello World!' > /tmp/file1",
          "name" => "task-4",
          "requires" => ["task-3"]
        },
        %{"command" => "rm /tmp/file1", "name" => "task-2"}
      ]

      {:ok, actual_data} = Process.task_list(data)

      expected_data = [
        %{"command" => "rm /tmp/file1", "name" => "task-2"},
        %{"command" => "cat /tmp/file1", "name" => "task-3"},
        %{"command" => "touch /tmp/file1", "name" => "task-1"},
        %{"command" => "echo 'Hello World!' > /tmp/file1", "name" => "task-4"}
      ]

      assert actual_data == expected_data
    end

    test "successfully orders tasks with nested requires" do
      data = [
        %{"command" => "touch /tmp/file1", "name" => "task-1", "requires" => ["task-2"]},
        %{"command" => "cat /tmp/file1", "name" => "task-3", "requires" => ["task-4"]},
        %{"command" => "echo 'Hello World!' > /tmp/file1", "name" => "task-4"},
        %{"command" => "rm /tmp/file1", "name" => "task-2", "requires" => ["task-3"]}
      ]

      {:ok, actual_data} = Process.task_list(data)

      expected_data = [
        %{"command" => "echo 'Hello World!' > /tmp/file1", "name" => "task-4"},
        %{"command" => "cat /tmp/file1", "name" => "task-3"},
        %{"command" => "rm /tmp/file1", "name" => "task-2"},
        %{"command" => "touch /tmp/file1", "name" => "task-1"}
      ]

      assert actual_data == expected_data
    end

    test "successfully orders tasks with multiple nested requires" do
      data = [
        %{"command" => "task-1", "name" => "task-1", "requires" => ["task-2", "task-3"]},
        %{
          "command" => "task-2",
          "name" => "task-2",
          "requires" => ["task-3", "task-5", "task-4"]
        },
        %{"command" => "task-3", "name" => "task-3", "requires" => ["task-4", "task-5"]},
        %{"command" => "task-4", "name" => "task-4"},
        %{"command" => "task-5", "name" => "task-5", "requires" => ["task-4"]}
      ]

      {:ok, actual_data} =
        Process.task_list(data)

      expected_data = [
        %{"command" => "task-4", "name" => "task-4"},
        %{"command" => "task-5", "name" => "task-5"},
        %{"command" => "task-3", "name" => "task-3"},
        %{"command" => "task-2", "name" => "task-2"},
        %{"command" => "task-1", "name" => "task-1"}
      ]

      assert actual_data == expected_data
    end

    test "fails to order tasks with circular dependency" do
      data = [
        %{"command" => "task-1", "name" => "task-1", "requires" => ["task-2", "task-3"]},
        %{
          "command" => "task-2",
          "name" => "task-2",
          "requires" => ["task-3", "task-5", "task-4"]
        },
        %{"command" => "task-3", "name" => "task-3", "requires" => ["task-4", "task-5"]},
        %{"command" => "task-4", "name" => "task-4"},
        %{"command" => "task-5", "name" => "task-5", "requires" => ["task-1"]}
      ]

      {:error, actual_error} = Process.task_list(data)

      assert actual_error == "Circular dependency for task-1"
    end
  end

  describe "to_bash/1" do
    test "successfully cast processed task list to bash script" do
      data = [
        %{"command" => "task-4", "name" => "task-4"},
        %{"command" => "task-5", "name" => "task-5"},
        %{"command" => "task-3", "name" => "task-3"},
        %{"command" => "task-2", "name" => "task-2"},
        %{"command" => "task-1", "name" => "task-1"}
      ]

      actual = Process.to_bash(data)

      expected = [
        "#!/usr/bin/env bash",
        "task-4",
        "task-5",
        "task-3",
        "task-2",
        "task-1"
      ]

      assert actual == expected
    end
  end
end
