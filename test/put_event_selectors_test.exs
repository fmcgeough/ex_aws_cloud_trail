defmodule PutEventSelectorsTest do
  use ExUnit.Case

  test "normal op" do
    selectors = [
      [
        include_management_events: true,
        read_write_type: "All"
      ]
    ]

    op = ExAws.CloudTrail.put_event_selectors("Default", selectors)

    assert op.headers == [
             {"x-amz-target", "CloudTrail_20131101.PutEventSelectors"},
             {"content-type", "application/x-amz-json-1.1"}
           ]

    assert op.data == %{
             "EventSelectors" => [
               %{"IncludeManagementEvents" => true, "ReadWriteType" => "All"}
             ],
             "TrailName" => "Default"
           }
  end
end
