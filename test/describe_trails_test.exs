defmodule DescribeTrailsTest do
  use ExUnit.Case

  test "describe all" do
    op = ExAws.CloudTrail.describe_trails()

    assert op.headers == [
             {"x-amz-target", "CloudTrail_20131101.DescribeTrails"},
             {"content-type", "application/x-amz-json-1.1"}
           ]

    assert op.data == %{}
  end

  test "arn list" do
    trail_arn_list = ["arn:aws:cloudtrail:us-east-1:12345678:trail/Testing"]
    op = ExAws.CloudTrail.describe_trails(trail_name_list: trail_arn_list)

    assert op.headers == [
             {"x-amz-target", "CloudTrail_20131101.DescribeTrails"},
             {"content-type", "application/x-amz-json-1.1"}
           ]

    assert op.data == %{
             "trailNameList" => ["arn:aws:cloudtrail:us-east-1:12345678:trail/Testing"]
           }
  end

  test "arn list with include shadow trails" do
    trail_arn_list = ["arn:aws:cloudtrail:us-east-1:12345678:trail/Testing"]

    op =
      ExAws.CloudTrail.describe_trails(
        trail_name_list: trail_arn_list,
        include_shadow_trails: true
      )

    assert op.headers == [
             {"x-amz-target", "CloudTrail_20131101.DescribeTrails"},
             {"content-type", "application/x-amz-json-1.1"}
           ]

    assert op.data == %{
             "includeShadowTrails" => true,
             "trailNameList" => ["arn:aws:cloudtrail:us-east-1:12345678:trail/Testing"]
           }
  end
end
