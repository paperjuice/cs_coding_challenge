defmodule CraftingSoftwareWeb.MainLive.Index do
  @moduledoc false

  alias CraftingSoftware.Process

  use CraftingSoftwareWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    updated_socket =
      socket
      |> assign(:placeholder_task_list, placeholder_task())
      |> assign(:processed_task_list, "")
      |> assign(:bash_script, [])

    {:ok, updated_socket}
  end

  @impl true
  def handle_event("generate", _, socket) do
    generated_task_list = Process.generate_random_task_list()
    json_task_list = Jason.encode!(generated_task_list, pretty: true)

    updated_socket =
      assign(socket, :placeholder_task_list, json_task_list)

    {:noreply, updated_socket}
  end

  @impl true
  def handle_event("process", %{"task_list" => task_list}, socket) do
    updated_socket =
      with {:ok, full_data} <- Jason.decode(task_list),
           %{"tasks" => task_list} <- full_data,
           {:ok, processed_data} <- Process.task_list(task_list),
           bash_script <- Process.to_bash(processed_data) do

        json_response =
          processed_data
          |> build_response()
          |> Jason.encode!(pretty: true)

        socket
        |> assign(:processed_task_list, json_response)
        |> assign(:bash_script, bash_script)
        |> put_flash(:info, "Processing successful")
    else
      {:error, reason} ->
        put_flash(socket, :error, "Processing failed with reason: #{inspect(reason)}")
    end

    {:noreply, updated_socket}
  end

  # ---------------------------------------------
  #                    PRIVATE
  # ---------------------------------------------

  defp placeholder_task do
    """
    {
      "tasks": [
        {
          "name": "task-1"
          ,
          "command": "touch /tmp/file1"
        },
        {
          "name": "task-2"
          ,
          "command":"cat /tmp/file1"
          ,
          "requires":[
            "task-3"
          ]
        },
        {
          "name": "task-3"
          ,
          "command": "echo 'Hello World!' > /tmp/file1"
          ,
          "requires":[
            "task-1"
          ]
        },
        {
          "name": "task-4"
          ,
          "command": "rm /tmp/file1"
          ,
          "requires":[
            "task-2"
            ,
            "task-3"
          ]
        }
        ]
      }
      """
  end

  defp build_response(processed_data) do
    tasks = Enum.map(processed_data, fn pd ->
      #TODO: remove "requires" directly in the processing function instead of
      # iterrating through again
      %{
        "command" => pd["command"],
        "name" => pd["name"]
      }
    end)

    %{
      "tasks" => tasks
    }
  end

end
