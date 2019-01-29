defmodule ListTagsTest do
  use ExUnit.Case

  test "list_tags" do
    op = ExAws.CloudTrail.list_tags("arn:aws:cloudtrail:us-east-2:123456789012:trail/MyTrail")

    assert op.headers == [
             {"x-amz-target", "CloudTrail_20131101.ListTags"},
             {"content-type", "application/x-amz-json-1.1"}
           ]

    assert op.data == %{
             "ResourceTagList" => "arn:aws:cloudtrail:us-east-2:123456789012:trail/MyTrail"
           }
  end

  test "list tags with paging" do
    op =
      ExAws.CloudTrail.list_tags("arn:aws:cloudtrail:us-east-2:123456789012:trail/MyTrail",
        next_token: "ABCDEF"
      )

    assert op.headers == [
             {"x-amz-target", "CloudTrail_20131101.ListTags"},
             {"content-type", "application/x-amz-json-1.1"}
           ]

    assert op.data == %{
             "ResourceTagList" => "arn:aws:cloudtrail:us-east-2:123456789012:trail/MyTrail",
             "NextToken" => "ABCDEF"
           }
  end
end
