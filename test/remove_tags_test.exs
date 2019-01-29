defmodule RemoveTagsTest do
  use ExUnit.Case

  test "remove tags from a trail" do
    arn = "arn:aws:cloudtrail:us-east-2:123456789012:trail/MyTrail"
    tags = [%{key: "Key", value: "Value"}, %{key: "Key2", value: "Value2"}]
    op = ExAws.CloudTrail.remove_tags(arn, tags)

    assert op.headers == [
             {"x-amz-target", "CloudTrail_20131101.RemoveTags"},
             {"content-type", "application/x-amz-json-1.1"}
           ]

    assert op.data == %{
             "ResourceId" => "arn:aws:cloudtrail:us-east-2:123456789012:trail/MyTrail",
             "TagsList" => [
               %{"Key" => "Key", "Value" => "Value"},
               %{"Key" => "Key2", "Value" => "Value2"}
             ]
           }
  end
end
