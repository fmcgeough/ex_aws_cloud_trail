defmodule StopLoggingTest do
  use ExUnit.Case

  test "stop logging" do
    arn = "arn:aws:cloudtrail:us-east-2:123456789012:trail/MyTrail"
    op = ExAws.CloudTrail.stop_logging(arn)

    assert op.headers == [
             {"x-amz-target", "CloudTrail_20131101.StopLogging"},
             {"content-type", "application/x-amz-json-1.1"}
           ]

    assert op.data == %{
             "Name" => "arn:aws:cloudtrail:us-east-2:123456789012:trail/MyTrail"
           }
  end
end
