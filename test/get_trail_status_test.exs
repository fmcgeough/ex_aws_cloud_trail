defmodule GetTrailStatusTest do
  use ExUnit.Case

  # Returned data from get_trail_status looks like this:
  #
  # {:ok,
  #  %{
  #    "IsLogging" => true,
  #    "LatestDeliveryAttemptSucceeded" => "2019-01-28T19:56:09Z",
  #    "LatestDeliveryAttemptTime" => "2019-01-28T19:56:09Z",
  #    "LatestDeliveryTime" => 1548705369.96,
  #    "LatestNotificationAttemptSucceeded" => "",
  #    "LatestNotificationAttemptTime" => "",
  #    "StartLoggingTime" => 1442928080.135,
  #    "StopLoggingTime" => 1442928012.831,
  #    "TimeLoggingStarted" => "2015-09-22T13:21:20Z",
  #    "TimeLoggingStopped" => "2015-09-22T13:20:12Z"
  #  }}

  test "normal op" do
    arn = "arn:aws:cloudtrail:us-east-2:123456789012:trail/MyTrail"
    op = ExAws.CloudTrail.get_trail_status(arn)

    assert op.headers == [
             {"x-amz-target", "CloudTrail_20131101.GetTrailStatus"},
             {"content-type", "application/x-amz-json-1.1"}
           ]

    assert op.data == %{"Name" => arn}
  end
end
