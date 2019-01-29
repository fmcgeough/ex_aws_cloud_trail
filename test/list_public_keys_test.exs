defmodule ListPublicKeysTest do
  use ExUnit.Case

  test "no params" do
    op = ExAws.CloudTrail.list_public_keys()

    assert op.headers == [
             {"x-amz-target", "CloudTrail_20131101.ListPublicKeys"},
             {"content-type", "application/x-amz-json-1.1"}
           ]

    assert op.data == %{}
  end

  test "with start and end time (in epoch)" do
    [start_time, end_time] =
      ["2019-01-15T21:24:04Z", "2019-02-14T21:24:04Z"]
      |> Enum.map(fn iso ->
        case DateTime.from_iso8601(iso) do
          {:ok, dt, _offset} -> DateTime.to_unix(dt)
          _ -> 0
        end
      end)

    op = ExAws.CloudTrail.list_public_keys(start_time: start_time, end_time: end_time)

    assert op.data == %{"StartTime" => start_time, "EndTime" => end_time}
  end
end
