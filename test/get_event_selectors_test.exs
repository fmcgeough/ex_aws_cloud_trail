defmodule GetEventSelectorsTest do
  use ExUnit.Case

  test "normal op" do
    op = ExAws.CloudTrail.get_event_selectors("Default")

    assert op.headers == [
             {"x-amz-target", "CloudTrail_20131101.GetEventSelectors"},
             {"content-type", "application/x-amz-json-1.1"}
           ]

    assert op.data == %{"TrailName" => "Default"}
  end
end
