defmodule CraftingSoftware.Process do
  @moduledoc """
  Module for handling general business logic
  """

  require Logger

  @doc """
  Example parameter format:
  [
    %{"command" => "touch /tmp/file1", "name" => "task-1", "requires" => ["task-2"]},
    %{"command" => "cat /tmp/file1", "name" => "task-2", "requires" => ["task-3", "task-4"]},
    %{
      "command" => "echo 'Hello World!' > /tmp/file1",
      "name" => "task-3",
      "requires" => ["task-1"]
    },
    %{
      "command" => "rm /tmp/file1",
      "name" => "task-4",
      "requires" => ["task-3"]
    }
  ]
  """
  @spec task_list(list()) :: {:ok, list()} | {:error, String.t()}
  def task_list(task_list) do
    process_task(task_list, [])
  end

  def to_bash(processed_task_list) do
    init_acc =[
      "#!/usr/bin/env bash"
    ]

    processed_task_list
    |> Enum.reduce(init_acc, fn task, acc ->
      [task["command"]|acc]
    end)
    |> Enum.reverse()
  end

  def generate_random_task_list do
    generate()
  end

  # ---------------------------------------------
  #                    PRIVATE
  # ---------------------------------------------

  defp process_task([], results), do: {:ok, Enum.uniq(results)}

  defp process_task([task | collection], results) do
    case handle_requires(task["requires"], task, collection, [], results) do
      {:ok, updated_result} ->
        process_task(collection, updated_result)

      {:error, reason} ->
        Logger.error("Circular dependency found")
        {:error, reason}
    end
  end


  defp handle_requires(_, nil, _collection, _, result), do: {:ok, result}

  defp handle_requires(requires, task, _collection, [], result) when requires in [[], nil],
    do: {:ok, [task | result]}

  defp handle_requires(requires, task, collection, temp, result) when requires in [[], nil] do
    updated_result = result ++ [task]
    updated_temp = remove_task_from_collection(task, temp)
    updated_collection = remove_task_from_collection(task, collection)

    new_task = List.first(updated_temp)

    handle_requires(
      new_task["requires"],
      new_task,
      updated_collection,
      updated_temp,
      updated_result
    )
  end

  defp handle_requires([require_hd | require_tl], task, collection, temp, result) do
    found_task =
      Enum.find(collection, fn c -> c["name"] == require_hd end) ||
        Enum.find(result, fn r -> r["name"] == require_hd end)

    if found_task do
      updated_task = Map.put(task, "requires", require_tl)
      updated_collection = remove_task_from_collection(task, collection)
      updated_temp = [updated_task | temp]

      handle_requires(
        found_task["requires"],
        found_task,
        updated_collection,
        updated_temp,
        result
      )
    else
      {:error, "Circular dependency for #{require_hd}"}
    end
  end

  defp remove_task_from_collection(task, collection) do
    Enum.reject(collection, fn c -> c["name"] == task["name"] end)
  end

  defp generate do
    max_task_num = Enum.random(4..15)

    task_list =
    Enum.map(1..max_task_num, fn counter ->
      task = %{
        "command" => "echo 'task-#{counter}'",
        "name" => "task-#{counter}"
      }

      0..4
      |> Enum.random()
      |> requires_task_gen(counter, max_task_num, task)
    end)

    %{"tasks" => task_list}
  end

  defp requires_task_gen(0, _self_number, _max_num, task), do: task

  defp requires_task_gen(num_of_requires, self_number, max_num, task) do
    requires =
      1..num_of_requires
      |> Enum.map(fn _ ->
        number =
          1..max_num
          |> Enum.reject(&(&1 == self_number))
          |> Enum.random()

        "task-#{number}"
      end)
      |> Enum.uniq()

    Map.put(task, "requires", requires)
  end
end
