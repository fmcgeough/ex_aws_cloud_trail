defmodule DeleteTrailTest do
  use ExUnit.Case

  test "delete a trail" do
    op = ExAws.CloudTrail.delete_trail("TestTrail")

    assert op.headers == [
             {"x-amz-target", "CloudTrail_20131101.DeleteTrail"},
             {"content-type", "application/x-amz-json-1.1"}
           ]

    assert op.data == %{"Name" => "TestTrail"}
  end
end
