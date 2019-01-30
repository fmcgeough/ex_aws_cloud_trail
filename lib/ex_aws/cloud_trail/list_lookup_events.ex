defmodule ExAws.CloudTrail.ListLookupEvents do
  @moduledoc """
    Provide a helper for users of library to list all events

    A common use case for the CloudTrail library is to lookup
    events. The events may be paged (more than 50 results). This
    module allows a caller to gather all the events rather than
    handling paging themselves. The module uses Logger to output
    warnings if an error occurs in AWS API calls.

  ## Example Usage

      # Get all events on an EC2 instance
      opts = [lookup_attributes: [attribute_key: "ResourceName", attribute_value: "i-12345678"]]
      {:ok, events} = ListLookupEvents.list_lookup_events(opts, keys)
  """
  alias ExAws.CloudTrail
  require Logger

  @doc """
    Return all CloudTrail events that match the opts criteria

  ## Returns

        {:ok, [Event,...} on success or {:error, []} on failure
  """
  def list_lookup_events(opts, keys) do
    {result, events} = aws_list_lookup_events(keys, opts)
    handle_paging(result, events["Events"], events["NextToken"], opts, keys)
  end

  defp handle_paging(:ok, acc, nil, _opts, _keys), do: {:ok, acc}
  defp handle_paging(:error, _acc, nil, _opts, _keys), do: {:error, []}

  defp handle_paging(:ok, acc, next_token, opts, keys) do
    new_opts = Enum.concat(opts, next_token: next_token)
    {result, events} = aws_list_lookup_events(keys, new_opts)

    handle_paging(
      result,
      Enum.concat(acc, events["Events"]),
      events["NextToken"],
      opts,
      keys
    )
  end

  defp aws_list_lookup_events(keys, opts) do
    opts
    |> CloudTrail.lookup_events()
    |> ExAws.request(keys)
    |> case do
      {:ok, data} ->
        {:ok, data}

      result ->
        Logger.warn(inspect(result))
        {:error, %{"Events" => []}}
    end
  end
end
